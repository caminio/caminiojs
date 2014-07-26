class OrganizationalUnit < ActiveRecord::Base

  serialize :settings, JSON
  has_many :users, through: :organizational_unit_members
  has_many :app_model_user_roles
  belongs_to  :owner, class_name: 'User'

end
