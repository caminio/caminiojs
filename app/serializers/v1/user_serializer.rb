module V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :email, :firstname, :lastname, :role, :valid_until
    has_many :organizations, embed_in_root: true, embed: :ids
  end
end