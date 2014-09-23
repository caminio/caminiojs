require 'securerandom'

class Users::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    optional :simple_list, default: false
    optional :q
  end
  get '/', root: 'users' do
    authenticate!
    users = User.where organizational_units: headers['Ou']
    users = users.any_of firstname: /#{params.q}/, lastname: /#{params.q}/, email: /#{params.q}/
    return users.map{ |u| { name: u.name, email: u.email, formattedName: "<strong>#{u.name}</strong> #{u.email}" } } if params[:simple_list]
    users
  end

  desc "invites a user to the organizational unit. sends email if does not exist"
  params do
    requires :user, type: Hash do
      requires :email, type: String
      requires :locale, type: String
    end
    optional :app_model_user_roles, type: Hash do
      optional :app_model_id, type: Integer
      optional :access_level, type: Integer
    end
  end
  post '/' do
    unless user = User.find_by( email: params[:user][:email] )
      user = User.new( email: params[:user][:email], locale: params[:user][:locale] )
      user.gen_confirmation_key
      user.password = SecureRandom.hex
      user.organizational_unit_members.build organizational_unit: current_organizational_unit
      params[:app_model_user_roles].each_pair do |key,app_model_ur|
        next if app_model_ur[:access_level] == "0"
        user.app_model_user_roles.build app_model_id: app_model_ur[:app_model_id], organizational_unit_id:  headers['Ou'], access_level: app_model_ur[:access_level]
      end
      begin
        return error!(user.errors.full_messages,500) unless user.save
      rescue
        return error!('user amount exceeded',509)
      end

      return user
      # if UserMailer.invite( user, current_user, "#{host_url}/caminio#/sessions/initial_setup?email=#{user.email}&confirmation_key=#{user.confirmation_key}").deliver
      #   return user
      # else
      #   error!('failed to send email', 500)
      # end
    end
  end

  desc "deletese a user (from organizational unit or entirely)"
  delete '/:id' do
    authenticate!
    error!('not found', 404) unless user = User.find( params[:id] )
    error!('insufficient rights', 403) unless ( current_user.id == user.id || current_user.id == current_organizational_unit.owner_id )
    unless user.organizational_unit_members.where( organizational_unit_id: current_organizational_unit.id ).destroy_all
      error!('failed destroying organizational_unit_members',500)
    end
    unless user.app_model_user_roles.where( organizational_unit_id: current_organizational_unit.id ).destroy_all
      error!('failed destroying app_plan_user_roles',500)
    end
    user
  end

  desc "updates a user's attributes"
  params do
    requires :user, type: Hash do
      requires :email, type: String
      optional :firstname, type: String
      optional :lastname, type: String
      optional :description, type: String
      optional :locale, type: String
      optional :phone, type: String
      optional :username, type: String
      optional :password, type: String, default: nil
      optional :password_confirmation, type: String, default: nil
      optional :cur_password, type: String, default: nil
    end
  end
  put '/:id' do
    authenticate!
    error!('not found',404) unless user = User.find( params[:id] )
    error!('security transgression',403) unless (current_user.id == params[:id] || current_user.id == current_organizational_unit.owner_id)
    if current_user.id.to_s == params[:id] && !params[:user][:password].blank?
      error!('cur_password_wrong',403) unless user.authenticate( params[:user][:cur_password] )
      error!('password_mismatch',409) unless user.update( password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
    else
      user_params = declared(params)[:user].reject{ |k| k.to_s =~ /password/ }
      puts "declared #{user_params}"
      error!('failed',500) unless user.update user_params
    end
    user
  end

  post '/avatar' do
    authenticate!
    if current_user.update( avatar: params[:avatar] )
      return { user: current_user }
    else
      return current_user.errors.messages
    end
  end

  params do
    requires :email, type: String
  end
  post '/send_password_link' do
    error!('Email unknown',403) unless user = 
      User.find_by_email( params[:email] )
    error!(error.messages.full_messages,500) unless user.gen_confirmation_key!
    error!('Mailer error',500) unless UserMailer.reset_password( 
      user, 
      "#{host_url}/caminio#/sessions/reset_password?id=#{user.id}&confirmation_key=#{user.confirmation_key}" ).deliver
    {}
  end

  params do
    requires :password, type: String
    requires :confirmation_key, type: String
  end
  post '/:id/reset_password' do
    error!('Confirmation key error',409) unless user = User.find_by( id: params[:id], confirmation_key: params[:confirmation_key] )
    error!('Confirmation key has expired',419) if user.confirmation_key_expires_at < Time.now
    user.password = params[:password]
    user.confirmation_key = nil
    user.confirmation_key_expires_at = nil
    error!(user.errors.full_messages,500) unless user.save
    { api_key: user.api_keys.create }
  end

  params do
    requires :email
    requires :password
    requires :locale
    optional :company_name
  end
  post '/signup' do
    error! 'Email exists', 409 if User.where(email: params.email).first
    user = User.new( 
      email: params[:email],
      password: params[:password],
      locale: params[:locale])
    ou = OrganizationalUnit.create name: params.company_name || 'private'
    ou.users << user
    if ou.save && user.save
      if UserMailer.welcome( user, "#{host_url}/caminio#/account").deliver
        { api_key: user.api_keys.create }
      else
        error! 'Mailer errror', 500
      end
    else
      Rails.logger.error user.errors.inspect
      if user.errors.messages[:email]
        error! 'Invalid email', 422
      elsif user.errors.messages[:password]
        error! 'Invalid password', 422
      end
    end
  end

  get '/:id', root: 'user' do
    authenticate!
    User.find(params[:id])
  end

  get '/:id/profile_picture' do
    authenticate!
    filename = File::expand_path("../../../assets/images/missing_bot_128x128.png",__FILE__)
    content_type MIME::Types.type_for(filename)[0].to_s
    env['api.format'] = :binary
    header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(filename)}"
    body( (File::open filename).read )
  end

end
