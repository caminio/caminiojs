class AppModelUserRoleSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :app_model_id, :organizational_unit_id, :access_level
  has_one :app_model, embed_in_root: true
end
