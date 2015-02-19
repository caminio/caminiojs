class AppBillEntity < Grape::Entity
  
  expose :id
  expose :paid_at
  expose :created_at
  expose :currency

  expose :app_bill_entry_ids do |bill|
    bill.app_bill_entries.map &:id
  end

end
