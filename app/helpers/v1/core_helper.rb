module V1

  module CoreHelper

    def logger
      Rails.logger
    end

    def base_url
      request.host_with_port
    end

  end

end
