class Label
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia

  field :name, type: String
  field :description, type: String
  field :fgcolor, type: String
  field :bgcolor, type: String
  field :bdcolor, type: String

  embeds_many :activities

  has_access_rules

end
