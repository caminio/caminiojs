class Sessions::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    requires :login
    requires :password
    optional :permanent, type: Boolean
  end
  post '/' do
    error!('401 Unauthorized', 401) unless user = User.any_of( { email: params.login }, { username: params.login } ).first.try(:authenticate, params[:password])
    user.api_keys.where(:expires_at.lt => Time.now).map(&:destroy)
    user.update_attributes last_login_at: Time.now, last_login_ip: env['REMOTE_ADDR']
    user.api_keys.create permanent: params.permanent
  end

  delete '/' do
    authenticate!
    token = headers['Authorization'] ? headers['Authorization'].split(' ').last : 'ERROR'
    error!('Server Error', 500) unless ApiKey.delete(access_token: token)
    return {}
  end

end
