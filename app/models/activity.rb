class Activity
  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  field :name
  field :item_id
  field :item_type
  field :created_at
  field :created_by

  belongs_to :organization

end