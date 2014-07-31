module Caminio
  module API
    module Helpers

      def logger
        Grape::API.logger
      end

      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        puts headers.inspect
        return false unless headers.has_key?('Authorization')
        if api_key = ApiKey.where("access_token = ? AND expires_at > ?", headers['Authorization'].split(' ').last, 8.hours.ago).first
          return @current_user = api_key.user
        end
        false
      end

      def host_url
        request.host_with_port
      end


    end

  end
end
