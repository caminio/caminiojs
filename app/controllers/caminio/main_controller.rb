class Caminio::MainController < ActionController::Base

  include Caminio::ControllerCommons

  protect_from_forgery with: :exception
  layout 'caminio'

  def index
  end

end
