class AppPlan
  include Mongoid::Document

  field :name, type: String
  field :price, type: Integer # price in cent. 5.00 EUR is saved as 500
  field :content_quota, type: Integer
  field :users_quota, type: Integer
  field :disk_quota, type: Integer
end
