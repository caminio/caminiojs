class OrganizationalUnitSerializer < ActiveModel::Serializer

  attributes :id, :name
  has_many :app_plans, embed: :ids, include: true

end
