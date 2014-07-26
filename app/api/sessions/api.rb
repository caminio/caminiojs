class Sessions::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  post '/' do
    error!('401 Unauthorized', 401) unless @user = User.where( "email = ? OR username = ?", params[:login], params[:login] ).first.try(:authenticate, params[:password])
    #invalidate other logins:
    @user.api_keys.delete_all
    { api_key: @user.api_keys.create }
  end

  delete '/' do
    if apiKey = ApiKey.find_by(access_token: headers['Authorization'].split(' ').last)
      return { api_key: apiKey } if apiKey.destroy
      error! 'Server Error', 500
    end
    error! 'Unauthorized', 401
  end

end
