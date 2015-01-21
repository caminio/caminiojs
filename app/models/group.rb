class Group

  include Mongoid::Document
  include Caminio::Userstamps
  include Caminio::Timestamps

  field :name, type: String
  field :settings, type: Object

  belongs_to :organization
  has_and_belongs_to_many :users

end
