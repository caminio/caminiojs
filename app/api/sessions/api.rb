class Sessions::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    requires :login
    requires :password
  end
  post '/' do
    error!('401 Unauthorized', 401) unless user = User.any_of( { email: params.login }, { username: params.login } ).first.try(:authenticate, params[:password])
    user.api_keys.map(&:destroy)
    user.update_attributes last_login_at: Time.now, last_login_ip: env['REMOTE_ADDR']
    user.api_keys.create
  end

  delete '/' do
    if apiKey = ApiKey.find_by(access_token: headers['Authorization'].split(' ').last)
      return { api_key: apiKey } if apiKey.destroy
      error! 'Server Error', 500
    end
    error! 'Unauthorized', 401
  end

end
