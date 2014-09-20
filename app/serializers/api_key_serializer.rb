class ApiKeySerializer < ActiveModel::Serializer
  attributes :id, :expires_at, :user_id, :access_token
end
