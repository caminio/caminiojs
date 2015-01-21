class RequestTokenEntity < Grape::Entity

  expose :id
  expose :token
  expose :expires_at
  
end
