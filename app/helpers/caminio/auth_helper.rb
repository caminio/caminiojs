module Caminio
  module AuthHelper

    include ApplicationHelper

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

    def authenticate_public!
      set_locale
      return if try_authorize_organization_key
      authenticate!
    end

    def authenticate!
      error!('Unauthorized', 401) unless try_authorize_token
      set_locale
    end

    def current_user
      @token.user if @token
    end

    def current_organization
      Organization.find RequestStore.store['organization_id']
    end

    def try_authorize_organization_key
      get_token_from_header
      return false if @token.organization_id.nil?
      RequestStore.store['current_api_key_id'] = @token.id
      RequestStore.store['organization_id'] = @token.organization_id
      true   
    end

    def get_token_from_header
      if token = headers['Authorization']
        token = token.split(' ').last
      elsif params.api_key
        token = params.api_key
      end
      error!('MissingTokenOrApiKey', 401) unless token
      @token = ApiKey.find_by( token: token )
    end

    def try_authorize_token
      get_token_from_header unless @token
      return false unless @token
      RequestStore.store['current_user_id'] = @token.user.id.to_s
      if @token.user.organizations.first
        RequestStore.store['organization_id'] ||= headers['Organization-Id'] || @token.user.organizations.first.id.to_s
      end
      return false if @token.expires_at < Time.now
      @token.update_attributes(last_request_at: Time.now, expires_at: 8.hours.from_now)
      true
    end
    
  end
end
