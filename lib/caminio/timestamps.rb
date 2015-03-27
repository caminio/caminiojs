# require 'active_support/concern'
module Caminio

  module Timestamps
    
    extend ActiveSupport::Concern

    included do

      field :created_at, type: DateTime, default: lambda{ DateTime.now }
      field :updated_at, type: DateTime, default: lambda{ DateTime.now }

      after_update :set_updated_at

      protected

        def set_updated_at
          self.updated_at = DateTime.now
        end

    end
  end
end
