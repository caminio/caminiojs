# encoding: utf-8
module HasTranslations

  extend ActiveSupport::Concern

  module ClassMethods

    def has_translations(options={})

      attr_accessor :current_lang
        
      cattr_accessor  :options

      self.options = options

      include InstanceMethods

      belongs_to :creator, class_name: 'User', foreign_key: :created_by
      belongs_to :updater, class_name: 'User', foreign_key: :updated_by
      belongs_to :deleter, class_name: 'User', foreign_key: :deleted_by

      has_many :translations, as: :row

      after_create :check_for_default_translation

    end

  end

  module InstanceMethods

    def current_translation
      self.translations.where( :locale => current_lang || I18n.default_locale  ).first
    end

    private 

      def check_for_default_translation
        unless self.class.options[:defaults]
          self.translations.create( :locale => I18n.default_locale, :title => self.class.name )
        end
      end

  end

end

ActiveRecord::Base.send :include, HasTranslations
