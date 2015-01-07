class OrganizationEntity < Grape::Entity
  
  root :organizations, :organization

  expose :id
  expose :name
  expose :user_ids

end