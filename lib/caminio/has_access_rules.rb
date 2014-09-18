# encoding: utf-8
module HasAccessRules

  extend ActiveSupport::Concern

  module ClassMethods

    def has_access_rules(options={})

      # Caminio::ModelRegistry.add self.name, options
      
      include InstanceMethods
      embeds_many :access_rules

    end

  end

  module InstanceMethods
  end

end

# ActiveRecord::Base.send :include, HasAccessRules

