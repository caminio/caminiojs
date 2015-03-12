module Caminio

  module AccessRules

    extend ActiveSupport::Concern

    included do
      before_create :create_access_rules
      embeds_many :access_rules
      
      default_scope lambda { elem_match( access_rules: { 
        organization_id: BSON::ObjectId.from_string( RequestStore.store['organization_id']) } ) 
      }
    end

    def create_access_rules
      access_rules.build organization_id: RequestStore.store['organization_id'],
        user_id: RequestStore.store['current_user_id'],
        can_write: true,
        can_share: true,
        can_delete: true
    end

  end

end

