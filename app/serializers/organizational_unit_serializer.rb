class OrganizationalUnitSerializer < ActiveModel::Serializer

  attributes :id, :name, :owner_id
  has_many :app_plans, embed: :ids, embed_in_root: true
  has_many :apps, embed_in_root: true
  # has_many :users, embed_in_root: false, embed: :ids
  #
  def owner_id
    object.users.first.id
  end

end
