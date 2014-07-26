class Caminio::MainController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'caminio'

  def index
  end

end
