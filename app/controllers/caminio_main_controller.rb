class CaminioMainController < ActionController::Base

  before_action :set_locale
 
  def index
  end

  private

  def set_locale
    I18n.locale = get_browser_locale || params[:locale] || I18n.default_locale
  end

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