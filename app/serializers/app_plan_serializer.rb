class AppPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :app_id, :price, :user_quota, :disk_quota, :content_quota, :hidden, :app_id
end
