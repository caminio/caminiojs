module Caminio

  module AccessRules

    extend ActiveSupport::Concern

    included do
      before_create :create_access_rules
      embeds_many :access_rules
      
      default_scope lambda { elem_match( access_rules: { organizational_unit_id: BSON::ObjectId.from_string( RequestStore.store[:current_ou_id]), user_id: RequestStore.store[:current_user].id } ) }
    end

    def create_access_rules
      access_rules.build organizational_unit: RequestStore.store[:current_ou_id],
        user: RequestStore.store[:current_user],
        can_write: true,
        can_share: true,
        can_delete: true
    end

  end

end

