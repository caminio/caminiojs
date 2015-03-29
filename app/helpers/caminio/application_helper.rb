module Caminio

  module ApplicationHelper

    def set_organization
      set_locale
      RequestStore.store['organization_id'] = headers['Organization-Id']
    end
    
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

    def set_locale *args
      if headers['Accept-Language']
        locale =  headers['Accept-Language'].split(',').first
        locale = locale.sub(/-..$/,'')
        I18n.locale= locale
      elsif args[0]        
        I18n.locale = args[0]   
      else
        I18n.locale = params[:locale] || get_browser_locale || I18n.default_locale
      end
    end

    private

    def get_browser_locale
      accept_lang = request.env["HTTP_ACCEPT_LANGUAGE"]
      return if accept_lang.nil?
      langs = accept_lang.split(",").map { |l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
        l.split(';q=')
      }.sort { |a, b| b[1] <=> a[1] }
      return split_lang(langs.first.first)
    end

    def split_lang(lang)
      lang.split("-").first unless lang.nil?
    end

  end

end