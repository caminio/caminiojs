class Location
  include Mongoid::Document

  include Caminio::Userstamps
  # include Caminio::AccessRules

  field :name, type: String
  field :title, type: String, localize: true
  field :description, type: String, localize: true

  field :street, type: String
  field :zip, type: String
  field :city, type: String
  field :country_code, type: String
  field :state, type: String

  field :building, type: String
  field :stair, type: String
  field :floor, type: String
  field :room, type: String
  field :gkz, type: String
  field :addition, type: String

  field :lat, type: Float
  field :lng, type: Float

  field :url, type: String
  field :phone, type: String
  field :email, type: String

end
