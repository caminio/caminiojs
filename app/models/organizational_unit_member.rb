class OrganizationalUnitMember < ActiveRecord::Base
  belongs_to :organizational_unit
  belongs_to :user
end
