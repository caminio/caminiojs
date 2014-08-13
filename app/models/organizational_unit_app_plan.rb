class OrganizationalUnitAppPlan < ActiveRecord::Base

  belongs_to :app_plan
  belongs_to :organizational_unit

  before_destroy :clear_app_model_user_roles

  private

  def clear_app_model_user_roles
    app_plan.app.app_models.each do |app_model|
      AppModelUserRole.where( app_model: app_model, organizational_unit: organizational_unit ).map(&:destroy)
    end
  end

end
