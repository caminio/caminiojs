# encoding: utf-8
module HasLabels

  extend ActiveSupport::Concern

  module ClassMethods

    def has_labels(options={})

      Caminio::ModelRegistry.add self.name, options
      
      include InstanceMethods

      has_many :labels, through: :row_labels
      has_many :row_labels, as: :row, dependent: :delete_all

    end

  end

  module InstanceMethods
  end

end

# ActiveRecord::Base.send :include, HasLabels

