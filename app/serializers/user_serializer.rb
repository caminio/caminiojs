class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :avatar_thumb, :last_login_at
  
  has_many :organizational_units, embed: :ids, include: true
  has_many :app_models, embed: :ids, include: true


end
