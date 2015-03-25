module Caminio

  module ApplicationHelper
    
    def logger
      Caminio.logger
    end

    def base_url
      protocol ||= request.ssl? ? 'https://' : 'http://'
      "#{protocol}#{request.host_with_port}"
    end

    def set_current_organization
      if request.subdomains.first
        if @current_organization = Organization.find_by(fqdn: request.subdomains.first)
          RequestStore::store['organization_id'] = @current_organization.id
        end
      elsif headers['Organization-Id']
        if @current_organization = Organization.find(headers['Organization-Id'])
          RequestStore::store['organization_id'] = @current_organization.id
        end
      end
    end

  end

end