module Caminio

  module ControllerCommons

    extend ActiveSupport::Concern

    included do

      before_filter :set_locale

      private

      def set_locale
        I18n.locale = extract_locale_from_accept_language_header
      end

      def extract_locale_from_accept_language_header
        return unless request.env['HTTP_ACCEPT_LANGUAGE']
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end

    end

  end
end
