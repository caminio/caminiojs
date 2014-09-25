module Caminio

  module ControllerCommons

    extend ActiveSupport::Concern

    included do

      before_filter :cors_set_access_control_headers, :set_locale

      private

      def set_locale
        I18n.locale = extract_locale_from_accept_language_header
      end

      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Max-Age'] = "1728000"
      end

      def extract_locale_from_accept_language_header
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end

    end

  end
end
