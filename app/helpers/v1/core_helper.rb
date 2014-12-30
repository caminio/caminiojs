module V1

  module CoreHelper

    def logger
      Rails.logger
    end

    def base_url
      protocol ||= request.ssl? ? 'https://' : 'http://'
      "#{protocol}#{request.host_with_port}"
    end

  end

end
