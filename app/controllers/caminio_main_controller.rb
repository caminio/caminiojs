class CaminioMainController < ActionController::Base

  include Caminio::ApplicationHelper

  before_action :set_locale
  before_filter :set_current_organization
 
  def index
  end

end