class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :firstname, :lastname, :email, :avatar_thumb, :last_login_at, :locale
  
  has_many :organizational_units, embed: :ids, embed_in_root: true

end
