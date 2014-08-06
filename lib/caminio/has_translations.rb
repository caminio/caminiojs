# encoding: utf-8
module HasTranslations

  extend ActiveSupport::Concern

  module ClassMethods


    attr_accessor :current_lang
      
    cattr_accessor  :options

    def has_translations(options={})

      self.options = options

      include InstanceMethods

      belongs_to :creator, class_name: 'User', foreign_key: :created_by
      belongs_to :updater, class_name: 'User', foreign_key: :updated_by
      belongs_to :deleter, class_name: 'User', foreign_key: :deleted_by

      has_many :translations, as: :row


      before_create :check_for_default_translation
      # validate :check_if_updater_has_rights

      default_scope { where(deleted_at: nil) }

    end

  end

  module InstanceMethods

    def current_translation
      locale = current_lang || I18n.default_locale
      curTranslation = Translation.where( :row_id => self.id, :locale => locale  )
      puts curTranslation
    end

    def delete
      self.deleted_at = Time.now
      if defined?(children)
        children.each{ |child| child.delete }
      end
      self.save
    end

    def restore
      self.deleted_at = nil
      self.save
    end

    private 

      def check_for_default_translation
        
        unless self.class.options[:defaults]

        end

      end

    # def create_slug( name=name )
    #   #strip the string
    #   ret = name.strip

    #   #blow away apostrophes
    #   ret.gsub! /['`]/,""

    #   # @ --> at, and & --> and
    #   ret.gsub! /\s*@\s*/, " at "
    #   ret.gsub! /\s*&\s*/, " and "

    #   ret.gsub!(/[äöüß]/) do |match|
    #     case match
    #     when "ä" then 'ae'
    #     when "ö" then 'oe'
    #     when "ü" then 'ue'
    #     when "ß" then 'ss'
    #     end
    #   end

    #   #replace all non alphanumeric, underscore or periods with underscore
    #   ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'

    #   #convert double underscores to single
    #   ret.gsub! /_+/,"_"

    #   #strip off leading/trailing underscore
    #   ret.gsub! /\A[_\.]+|[_\.]+\z/,""

    #   self.slug = ret.downcase

    # end

  end

end

ActiveRecord::Base.send :include, HasTranslations
