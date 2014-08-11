class AppPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :app_id, :price, :user_quota, :disk_quota, :content_quota, :hidden
  has_many :translations, embed: :ids, include: true
  has_one :app, include: true
end
