module V1
  class ApiKeySerializer < ActiveModel::Serializer
    attributes :token, :expires_at, :user_id
  end
end
