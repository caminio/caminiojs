class AccessRuleSerializer < ActiveModel::Serializer
  attributes :id, :can_write, :can_share, :can_delete, :app_id, :user_id, :organizational_unit_id
end
