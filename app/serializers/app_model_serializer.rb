class AppModelSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :app_id, :path, :add_js
end
