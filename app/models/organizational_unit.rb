class OrganizationalUnit < ActiveRecord::Base

  serialize   :settings, JSON
  has_many    :users, through: :organizational_unit_members
  has_many    :app_plans, -> { distinct }, through: :organizational_unit_app_plans
  has_many    :organizational_unit_members
  has_many    :organizational_unit_app_plans
  has_many    :app_model_user_roles
  belongs_to  :owner, class_name: 'User'
  
  def link_apps(apps)
    apps.each_pair do |app_plan, value|
      if value
        OrganizationalUnitAppPlan.create( 
          :app_plan_id => app_plan, 
          :organizational_unit => self 
        )
      end
    end
  end
    
end
