class AppBill

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  embeds_many :app_bill_entries
  belongs_to :organization

  field :currency, type: String, default: 'EUR'
  field :paid_at, type: DateTime

end