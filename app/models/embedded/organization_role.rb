class OrganizationRole
  include Mongoid::Document
  
  embedded_in :user
  belongs_to :organization

  field :admin, type: Boolean, default: false
  field :editor, type: Boolean, default: false

end
