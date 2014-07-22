class OrganizationalUnit < ActiveRecord::Base

  serialize :settings, JSON
  has_many :users, through: :organizational_unit_members
  belongs_to  :owner, class_name: 'User'

end
