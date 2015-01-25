class Group

  include Mongoid::Document
  include Caminio::Userstamps
  include Caminio::Timestamps

  field :name, type: String
  field :settings, type: Object
  field :color, type: String, default: '#3F51B5'

  belongs_to :organization
  has_and_belongs_to_many :users

end
