class Caminio::MainController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'caminio'

  def index
    I18n.locale = extract_locale_from_accept_language_header
  end

  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
