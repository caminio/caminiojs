module Caminio
  module API
    module Helpers

      def logger
        Grape::API.logger
      end

      def authenticate!
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def current_token
        return unless api_key = ApiKey.where(access_token: headers['Authorization'].split(' ').last).gt(expires_at: Time.now).first
        api_key.access_token
      end

      def token_authenticate!
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
        access = Doorkeeper::AccessToken.authenticate(headers['Authorization'])
        return false unless access && access.valid?
        @user = User.find(access.resource_owner_id)
        @application = access.application.name
      end

      def current_user
        return false unless headers.has_key?('Authorization')
        if api_key = ApiKey.where(access_token: headers['Authorization'].split(' ').last).gt(expires_at: Time.now).first
          api_key.update! expires_at: 1.hour.from_now if api_key.expires_at < 1.hour.from_now
          I18n.locale = api_key.user.locale || I18n.locale
          RequestStore.store[:current_user] = api_key.user
          RequestStore.store[:current_ou_id] = headers['Ou']
          return @current_user = api_key.user
        end
        false
      end

      def current_organizational_unit
        return nil unless headers['Ou']
        ou = OrganizationalUnit.find(headers['Ou'])
        return unless current_user.organizational_units.include?(ou)
        RequestStore.store[:current_ou] = ou
        return ou
      end

      def host_url
        "#{request.prototol}#{request.host_with_port}"
        # protocol = "http#{"s" if request.scheme == 'https'}://"
        # protocol+request.host_with_port
      end

      def logo_url
        "#{host_url}#{asset_path('logo_128x128.png')}"
      end

    end

  end
end
