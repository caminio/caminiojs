# encoding: utf-8
module HasTranslations

  extend ActiveSupport::Concern

  module ClassMethods

    def has_translations(options={})

      attr_accessor :current_lang
        
      cattr_accessor  :default_values

      self.default_values = options[:defaults]

      include InstanceMethods

      belongs_to :creator, class_name: 'User', foreign_key: :created_by
      belongs_to :updater, class_name: 'User', foreign_key: :updated_by
      belongs_to :deleter, class_name: 'User', foreign_key: :deleted_by

      has_many :translations, as: :row, dependent: :delete_all

      after_create :check_for_default_translation

    end

  end

  module InstanceMethods

    def current_translation
      tr = self.translations.where( :locale => current_lang || I18n.default_locale  ).first
      tr = self.translations.where( :locale => I18n.default_locale  ).first unless tr
      tr = self.translations.first unless tr
      tr
    end

    private 

      def check_for_default_translation
        unless self.class.default_values
          self.translations.find_or_create_by(:locale => I18n.default_locale) do |tr|
            self.title = self.name
          end
        end
      end

  end

end

ActiveRecord::Base.send :include, HasTranslations
