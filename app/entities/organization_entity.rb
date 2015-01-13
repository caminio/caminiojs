class OrganizationEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :user_ids

end
