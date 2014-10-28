class AppModelSerializer < ActiveModel::Serializer
  attributes :id, :name, :app_id, :hidden
end
