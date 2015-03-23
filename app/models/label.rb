class Label
  include Mongoid::Document
  include Caminio::Userstamps
  include Caminio::Timestamps
  include Caminio::AccessRules

  field :name, type: String
  field :description, type: String
  field :category, type: String
  field :fgcolor, type: String
  field :bgcolor, type: String
  field :bdcolor, type: String

  embeds_many :activities


end
