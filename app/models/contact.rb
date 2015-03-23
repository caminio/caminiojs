class Contact

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps
  include Caminio::AccessRules

  field :firstname, type: String
  field :lastname, type: String
  field :email, type: String
  field :organization, type: String

  field :company, type: String
  field :degree, type: String
  field :gender, type: String
  field :phone, type: String

  field :locale, type: String, default: I18n.locale

  embeds_many :locations

  field :field_data, type: Hash
  has_and_belongs_to_many :labels

end
