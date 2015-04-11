class ApiKeyEntity < Grape::Entity

  expose :id
  expose :name
  expose :token
  expose :expires_at
  expose :ip_addresses
  expose :permanent
  expose :user_id
  expose :organization_id

  expose :created_at
  expose :created_by
  expose :updated_at
  expose :updated_by
  
end
