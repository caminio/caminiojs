module Caminio

  class ApplicationController < ActionController::Base

    def authenticate!
      render(json: { error: 'Unauthorized. Invalid or expired token.' }, status: 401) unless current_user
    end

    def current_user
      return false unless request.headers['Authorization']
      if api_key = ApiKey.where("access_token = ? AND expires_at > ?", request.headers['Authorization'].split(' ').last, 8.hours.ago).first
        return @current_user = api_key.user
      end
      false
    end

    def host_url
      request.host_with_port
    end

  end
end
