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

end
