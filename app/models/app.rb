class App
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps
  field :name, type: String, localize: true
  field :description, type: String, localize: true
  field :position, type: Integer
  field :additional_javascript, type: String
  field :url, type: String
  field :hidden, type: Boolean

  has_many :app_plans

end
