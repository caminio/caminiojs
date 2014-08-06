#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-25 16:44:58
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-29 16:57:31
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

class AppModelUserRole < ActiveRecord::Base
  belongs_to :user  
  belongs_to :app_model
  belongs_to :organizational_unit

  before_create :check_user_limitation

  private

   def check_user_limitation
      user_roles = AppModelUserRole.where( :organizational_unit => self.organizational_unit, :app_model => self.app_model ).load
      unit_plans = OrganizationalUnitAppPlan.where( :organizational_unit => self.organizational_unit )
      unit_plan = unit_plans.where(app_plans: { app_id: self.app_model.app_id}).includes(:app_plan).references(:app_plan).first
      
      if unit_plan && unit_plan.app_plan.users_amount <= user_roles.size
        raise StandardError.new("User amount does not allow more users")
      end
   end
end