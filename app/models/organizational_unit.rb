class OrganizationalUnit < ActiveRecord::Base

  serialize :settings, JSON
  has_many :users, through: :organizational_unit_members
  has_many :app_plans, through: :organizational_unit_app_plans
  has_many :organizational_unit_members
  has_many :organizational_unit_app_plans
  has_many :app_model_user_roles
  belongs_to  :owner, class_name: 'User'
  
  def link_apps(apps)
    apps.each_pair do |app_id|
      app_plan = AppPlan.where(:app_id => app_id ).first
      if app_plan
        OrganizationalUnitAppPlan.create( 
          :app_plan => app_plan, 
          :organizational_unit => self 
        )
      end
    end
  end
    

end
