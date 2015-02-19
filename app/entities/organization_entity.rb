class OrganizationEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :fqdn
  expose :user_quota

  expose :user_ids

  expose :app_bill_ids do |org|
    org.app_bills.map &:id
  end

  expose :last_paid_bill_id do |org|
    org.last_paid_bill && org.last_paid_bill.id.to_s
  end

end
