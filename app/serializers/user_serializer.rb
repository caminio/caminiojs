class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :firstname, :lastname, :email, :avatar_thumb, :last_login_at, :locale
  
  has_many :organizational_units, embed: :ids, embed_in_root: true
  has_many :access_rules, embed: :ids, embed_in_root: true

  def access_rules
    object.access_rules.where organizational_unit: RequestStore.store[:current_ou_id]
  end

end
