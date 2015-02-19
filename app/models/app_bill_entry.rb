class AppBillEntry

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  field :app_name, type: String
  field :name, type: String
  field :total_value, type: Integer # in cent 100 == 1.00, gross
  field :tax_rate, type: Integer # in percent
  
end