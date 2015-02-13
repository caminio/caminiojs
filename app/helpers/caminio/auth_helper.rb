module Caminio
  module AuthHelper
    def authenticate_user
      @current_user = User
              .or( [ { username: params.login }, { email: params.login } ] )
              .first
      return error!('InvalidCredentials',401) unless @current_user && @current_user.authenticate( params.password )
      RequestStore.store['current_user_id'] = @current_user.id.to_s
      if @current_user.organizations.first
        RequestStore.store['organization_id'] ||= @current_user.organizations.first.id.to_s
      end
      @current_user.update_attribute(:last_login_at, Time.now)
      @current_user.aquire_api_key
    end

    def authenticate!
      error!('Unauthorized', 401) unless try_authorize_token
    end

    def current_user
      @token.user if @token
    end

    def current_organization
      Organization.find RequestStore.store['organization_id']
    end

    def try_authorize_token
      if token = headers['Authorization']
        token = token.split(' ').last
      elsif params.api_key
        token = params.api_key
      end
      error!('MissingTokenOrApiKey', 401) unless token
      return false unless @token = ApiKey.find_by( token: token )
      RequestStore.store['current_user_id'] = @token.user.id.to_s
      if @token.user.organizations.first
        RequestStore.store['organization_id'] ||= headers['Organization-Id'] || @token.user.organizations.first.id.to_s
      end
      return false if @token.expires_at < Time.now
      @token.update_attributes(last_request_at: Time.now, expires_at: 8.hours.from_now)
      Activity.create name: 'activity.logged_in'
      true
    end

  end
end
