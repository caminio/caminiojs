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
    users = User.includes(:organizational_units).where("organizational_units.id=?", headers['Ou'] ).references(:organizational_units)
    users = users.where(["users.firstname LIKE ? OR users.lastname LIKE ? OR users.email LIKE ?"] + 3.times.collect{ "%#{params[:q]}%" }) unless params[:q].blank?
    return users.map{ |u| { name: u.name, email: u.email, formattedName: "<strong>#{u.name}</strong> #{u.email}" } } if params[:simple_list]
    users
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

  post '/signup' do
    error! 'Email exists', 409 if User.find_by_email params[:email]
    user = User.new( email: params[:email],
      password: params[:password],
      settings: { lang: params[:settings][:lang] },
      organizational_unit_name: params[:company_name].blank? ? "private" : params[:company_name])
    if user.save
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

  desc "invites a user to the organizational unit. sends email if does not exist"
  params do
    requires :email, type: String
    requires :settings, type: Hash
  end
  post '/invite' do
    unless user = User.first( email: params[:email] )
      user = User.new( email: params[:email], settings: params[:settings] )
      UserMailer.invite( user, "#{host_url}/caminio#/sessions/initial_setup?email=#{user.email}&confirmation_key=#{user.gen_confirmation_key}").deliver
    end
  end

  get '/:id', root: 'user' do
    authenticate!
    User.find_by_id(params[:id])
  end

  get '/:id/profile_picture' do
    filename = File::expand_path("../../../assets/images/missing_bot_128x128.png",__FILE__)
    content_type MIME::Types.type_for(filename)[0].to_s
    env['api.format'] = :binary
    header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(filename)}"
    body( (File::open filename).read )
  end

end
