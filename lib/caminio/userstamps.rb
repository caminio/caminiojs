# require 'active_support/concern'
module Caminio

  module Userstamps
    
    extend ActiveSupport::Concern

    included do

      belongs_to :created_by, class_name: 'User', inverse_of: nil
      belongs_to :updated_by, class_name: 'User', inverse_of: nil

      before_create :set_created_by
      before_save :set_updated_by

      protected

      def set_created_by
        return unless current_user = RequestStore.store[:current_user]
        self.created_by = current_user
      end

      def set_updated_by
        return unless current_user = RequestStore.store[:current_user]
        self.updated_by = current_user
      end

    end
  end
end
