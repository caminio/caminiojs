class ApiKeyEntity < Grape::Entity

  expose :id
  expose :name
  expose :token
  expose :expires_at
  
end
