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
    users = User.where organizational_unit_ids: headers['Ou']
    users = users.any_of(firstname: /#{params.q}/, lastname: /#{params.q}/, email: /#{params.q}/) if params.q
    return users.map{ |u| { name: u.name, email: u.email, formattedName: "<strong>#{u.name}</strong> #{u.email}" } } if params[:simple_list]
    users
  end

  desc "invites a user to the organizational unit. sends email if does not exist"
  params do
    requires :user, type: Hash do
      requires :email, type: String
      requires :locale, type: String
    end
  end
  post '/' do
    unless user = User.where( email: params[:user][:email] ).first
      user = User.new( email: params[:user][:email], locale: params[:user][:locale] )
      user.gen_confirmation_key
      user.password = SecureRandom.hex
      user.save
    end
    unless user.organizational_units.where(id: current_organizational_unit.id).first
      user.organizational_unit_ids << current_organizational_unit.id
      current_organizational_unit.user_ids << user.id
    end
    current_user.user_access_rules.each do |rule|
      next unless rule.can_share
      user.user_access_rules.create organizational_unit: current_organizational_unit, can_write: true, app_id: rule.app_id
    end
    return error!(user.errors.full_messages,500) unless user.save
    # return error!('user amount exceeded',509)
    error!('Mailer error',500) unless UserMailer.invite( 
                                                        user,
                                                        current_user,
                                                        "#{host_url}/caminio#/sessions/reset_password?id=#{user.id}&confirmation_key=#{user.confirmation_key}", host_url, logo_url ).deliver
    user
  end

  desc "deletese a user (from organizational unit or entirely)"
  delete '/:id' do
    authenticate!
    error!('not found', 404) unless user = User.find( params[:id] )
    error!('security transgression',403) unless (current_user.id == params[:id] || current_user.id == current_organizational_unit.users.first.id)
    current_organizational_unit.user_ids.delete user.id
    user.organizational_unit_ids.delete current_organizational_unit.id
    error!('failed to delete access rules',500) unless user.user_access_rules.where(organizational_unit: current_organizational_unit).destroy
    error!('failed to delete',500) unless user.save
    {}
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
    error!('security transgression',403) unless (current_user.id == params[:id] || current_user.id == current_organizational_unit.users.first.id)
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
    error!('Email unknown',403) unless user = User.where( email: params[:email] ).first
    error!(error.messages.full_messages,500) unless user.gen_confirmation_key!
    error!('Mailer error',500) unless UserMailer.reset_password( 
      user, 
      "#{host_url}/caminio#/sessions/reset_password?id=#{user.id}&confirmation_key=#{user.confirmation_key}", host_url, logo_url ).deliver
    {}
  end

  params do
    requires :password, type: String
    requires :confirmation_key, type: String
  end
  post '/:id/reset_password' do
    error!('Confirmation key error',409) unless user = User.where( id: params[:id], confirmation_key: params[:confirmation_key] ).first
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
    return error!('organization name taken',403) if params.company_name && OrganizationalUnit.where( name: /#{params.company_name}/i ).first
    user = User.new( 
      email: params[:email],
      password: params[:password],
      locale: params[:locale])
    ou = OrganizationalUnit.create owner_id: user.id, name: (params.company_name || 'private'), user_ids: [ user.id ]
    user.organizational_unit_ids << ou.id
    if user.save
      if UserMailer.welcome( user, "#{host_url}/caminio#/account", host_url, logo_url ).deliver
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
