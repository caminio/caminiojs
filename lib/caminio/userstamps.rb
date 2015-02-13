# require 'active_support/concern'
module Caminio

  module Userstamps
    
    extend ActiveSupport::Concern

    included do

      belongs_to :created_by, class_name: 'User', inverse_of: nil
      belongs_to :created_by_api_key, class_name: 'ApiKey', inverse_of: nil
      belongs_to :updated_by, class_name: 'User', inverse_of: nil

      before_create :set_creator
      before_save :set_updated_by

      protected

      def set_creator
        if current_api_key = RequestStore.store['current_api_key_id']
          return self.created_by_api_key = current_api_key
        elsif current_user = RequestStore.store['current_user_id']
          return self.created_by = current_user
        end
        raise 'Caminio API-Key constraint missing: neither current_api_key nor current_user is present in request_store'
      end

      def set_updated_by
        return unless current_user = RequestStore.store['current_user_id']
        self.updated_by = current_user
      end

    end
  end
end
