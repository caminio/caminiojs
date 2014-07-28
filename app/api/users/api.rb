class Users::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    authenticate!
    { users: User.where(organizational_units: headers['ou']) }
  end

  get '/:id/apps' do
    authenticate!
    [{ id: 1, name: 'messages', path: '/messages', icon: 'fa-envelope-o' }]
  end

  post '/reset_password' do
    error!('Email unknown',403) unless user = User.find_by_email( params[:email] )
    error!('Mail error',500) unless UserMailer.reset_password( user, "#{request.protocol}#{request.host}#{(!(/80|443/).match(request.port) ? '' : request.port)}/caminio#/sessions/reset_password?email=#{user.email}&confirmation_key=#{user.gen_confirmation_key!}" ).deliver
    {}
  end

  post '/signup' do
  end

  get '/:id' do
    authenticate!
    { user: User.find_by_id(params[:id]) }
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
