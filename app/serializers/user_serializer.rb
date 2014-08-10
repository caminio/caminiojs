class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :avatar_thumb
  
  has_many :organizational_units, embed: :ids, include: true
  has_many :app_models, embed: :ids, include: true


end
