class OrganizationalUnitSerializer < ActiveModel::Serializer

  attributes :id, :name
  has_many :app_plans, embed: :ids, embed_in_root: true
  has_many :apps, embed_in_root: true

end
