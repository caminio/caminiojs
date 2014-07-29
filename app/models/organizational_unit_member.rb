class OrganizationalUnitMember < ActiveRecord::Base
  belongs_to :organizational_unit
  belongs_to :user

  scope :allowed_apps, -> { user.app_model_user_roles.where( organizational_unit: organizational_unit ) }

  before_save :check_private_units

  private 

    def check_private_units
      @all_members = OrganizationalUnitMember.where( :organizational_unit => self.organizational_unit ).load
      if @all_members.size > 1 && organizational_unit.name == "private"
        raise StandardError.new("Private organizational_unit can only have 1 member") 
      end
    end

end
