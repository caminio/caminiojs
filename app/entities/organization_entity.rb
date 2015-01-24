class OrganizationEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :fqdn
  expose :user_quota

  expose :user_ids

end
