class OrganizationalUnitMember < ActiveRecord::Base
  belongs_to :organizational_unit
  belongs_to :user

  scope :allowed_apps, -> { user.app_model_user_roles.where( organizational_unit: organizational_unit ) }
end
