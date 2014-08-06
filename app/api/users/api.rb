class Users::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    # requires :ou, type: :integer
  end
  get '/', root: "users" do
    authenticate!
    User.includes(:organizational_units).where("organizational_units.id=?", headers['Ou'] ).references(:organizational_units)
  end

  get '/:id/apps' do
    authenticate!
    # unit = headers['Ou']
    # id = params['id']
    # roles = AppModelUserRole.where( 
    #   :organizational_unit_id => unit, 
    #   :user_id =>  id )
    # puts "we got"
    # puts roles.inspect
    # roles.each do |role|
    #   puts role.app_model.inspect

    # end

    [{ id: 1, name: 'messages', path: '/messages', icon: 'fa-envelope-o' }]
  end

  post '/avatar' do
    authenticate!
    if current_user.update( avatar: params[:avatar] )
      return { user: current_user }
    else
      return current_user.errors.messages
    end
  end

  post '/reset_password' do
    error!('Email unknown',403) unless user = 
      User.find_by_email( params[:email] )
    error!('Mailer error',500) unless UserMailer.reset_password( 
      user, 
      "#{host_url}/caminio#/sessions/reset_password?email=#{user.email}&confirmation_key=#{user.gen_confirmation_key!}" ).deliver
    {}
  end

  post '/signup' do
    error! 'Email exists', 409 if User.find_by_email params[:email]
    user = User.new( email: params[:email],
      password: params[:password],
      organizational_unit_name: params[:company_name])
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
