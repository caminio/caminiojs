class AppPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :app_id
  has_many :translations, embed: :ids, include: true
  has_one :app, include: true
end
