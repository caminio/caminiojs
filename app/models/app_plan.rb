class AppPlan

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  embedded_in :organization
  
  field :app_name, type: String
  field :price, type: Integer # in Cent x 100
  field :currency, type: String, default: 'EUR'
  field :subscription_ends_at, type: DateTime

end