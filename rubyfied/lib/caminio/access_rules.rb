module Caminio

  module AccessRules

    extend ActiveSupport::Concern

    included do
      before_create :create_access_rules
      embeds_many :access_rules
      
      default_scope lambda { elem_match( access_rules: { organizational_unit_id: BSON::ObjectId.from_string( RequestStore.store[:current_ou_id]) } ) }

      scope :anybody, lambda{ elem_match( access_rules: { user_id: User.find_or_create_by(email: 'anybody@camin.io').id }) }

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

