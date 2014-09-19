class AppPlan
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type: Integer # price in cent. 5.00 EUR is saved as 500
  field :content_quota, type: Integer
  field :user_quota, type: Integer
  field :disk_quota, type: Integer
  field :hidden, type: Boolean, default: true

  has_and_belongs_to_many :organizational_units
  belongs_to :app

end
