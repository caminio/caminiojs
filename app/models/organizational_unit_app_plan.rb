class OrganizationalUnitAppPlan < ActiveRecord::Base

  belongs_to :app_plan
  belongs_to :organizational_unit

end
