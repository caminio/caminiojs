module V1

  module AuthHelper
    
    def authenticate_user
      @current_user = User
              .where( "username=? OR email=?", params.login, params.login )
              .first
      return error!('InvalidCredentials',401) unless @current_user && @current_user.authenticate( params.password )
      @current_user.aquire_api_key
    end

    def authenticate!
      error!('Unauthorized', 401) unless try_authorize_token
    end

    def current_user
      @token.user if @token
    end

    def try_authorize_token
      if token = headers['Authorization']
        token = token.split(' ').last
      elsif params.api_key
        token = params.api_key
      end
      error!('MissingTokenOrApiKey', 401) unless token
      return false unless @token = ApiKey.find_by( token: token )
      @token.expires_at > Time.now
    end

  end
  
end