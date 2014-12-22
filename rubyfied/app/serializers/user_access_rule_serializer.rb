class UserAccessRuleSerializer < ActiveModel::Serializer
  attributes :id, :can_write, :can_share, :can_delete, :app_id, :organizational_unit_id

  has_one :user, embed: :ids, embed_in_root: false

end
