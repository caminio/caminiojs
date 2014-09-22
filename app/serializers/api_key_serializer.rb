class ApiKeySerializer < ActiveModel::Serializer
  attributes :id, :expires_at, :access_token, :user_id
end
