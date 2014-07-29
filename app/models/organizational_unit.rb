class OrganizationalUnit < ActiveRecord::Base

  serialize :settings, JSON
  has_many :users, through: :organizational_unit_members
  has_many :app_plans, through: :organizational_unit_app_plans
  has_many :organizational_unit_members
  has_many :organizational_unit_app_plans
  has_many :app_model_user_roles
  belongs_to  :owner, class_name: 'User'

  # before_save :check_private_for_more_users

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

  private 

    # def check_private_for_more_users
    #   puts "WE ARE HERE"
    #   puts  self.name
    #   puts self.users.size
    #   if self.name == "private" && self.users.size > 1
    #     raise StandardError.new("Private organizational_unit can only have 1 member")
    #   end
    # end

end
