class OrganizationalUnitSerializer < ActiveModel::Serializer

  attributes :id, :name, :owner_id, :fqdn
  has_many :app_plans, embed: :ids, embed_in_root: true
  has_many :apps, embed_in_root: true
  has_one :owner, embed: :ids, embed_in_root: false

end
