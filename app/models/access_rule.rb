class AccessRule
  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps
  
  field :can_write, type: Boolean, default: false
  field :can_share, type: Boolean, default: false
  field :can_delete, type: Boolean, default: false
  
  belongs_to :user
  belongs_to :organization

end
