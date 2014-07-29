class OrganizationalUnitMember < ActiveRecord::Base
  belongs_to :organizational_unit
  belongs_to :user

  scope :allowed_apps, -> { user.app_model_user_roles.where( organizational_unit: organizational_unit ) }

  before_save :check_private_units

  private 

    def check_private_units
      @all_members = OrganizationalUnitMember.where( :organizational_unit => self.organizational_unit ).load
      if @all_members.size > 1
        raise StandardError.new("Private organizational_unit can only have 1 member") if organizational_unit.name == "private"
        check_user_limitation
      end
    end

    def check_user_limitation
      user_roles = AppModelUserRole.where( :organizational_unit => self.organizational_unit ).load
      apps = []
      user_roles.each do |role|
        app_model = role.app_model
        apps.push(app_model.app) unless apps.include?(app_model.app)
      end
      puts apps.inspect
      apps.each do |app|
        # unit_app_plan = OrganizationalUnitAppPlan.where( :app => app, :organizational_unit => self.organizational_unit ).load.first
        # puts "THE PLAM"
        # puts unit_app_plan.inspect
        # if unit_app_plan &&  unit_app_plan.users_amount < @all_members
        #   puts "GOT HIM (:"
        # end
      end
      
    end
end
