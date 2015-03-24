class CaminioMainController < ActionController::Base

  include Caminio::ApplicationHelper

  before_filter :set_locale
  before_filter :set_current_organization
 
  def index
  end

end