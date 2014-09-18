class OrganizationalUnit

  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps

  field :name, type: String
  field :suspended, type: Boolean, default: false
  field :name, type: String
  
  belongs_to :owner, class_name: 'User'

  # def link_apps(apps)
  #   apps.each_pair do |app_plan, value|
  #     if value
  #       OrganizationalUnitAppPlan.create( 
  #         :app_plan_id => app_plan, 
  #         :organizational_unit => self 
  #       )
  #     end
  #   end
  # end
    
end
