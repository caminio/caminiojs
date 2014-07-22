# encoding: utf-8
module HasAccessRules

  extend ActiveSupport::Concern

  module ClassMethods
    def has_access_rules(options = {})

      include InstanceMethods

      belongs_to :creator, class_name: 'User', foreign_key: :created_by
      belongs_to :updater, class_name: 'User', foreign_key: :updated_by
      belongs_to :deleter, class_name: 'User', foreign_key: :deleted_by

      has_many :access_rules, as: :row

      after_create :create_default_rule

      default_scope { where(deleted_at: nil) }

    end
  end

  module InstanceMethods

    def create_default_rule
      self.access_rules.create(
        row_id: self.id,
        row_type: self.class.name,
        user_id: self.created_by,
        is_owner: true,
        created_by: self.created_by,
        updated_by: self.updated_by
      )
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

    def create_slug( name=name )
      #strip the string
      ret = name.strip

      #blow away apostrophes
      ret.gsub! /['`]/,""

      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "

      ret.gsub!(/[äöüß]/) do |match|
        case match
        when "ä" then 'ae'
        when "ö" then 'oe'
        when "ü" then 'ue'
        when "ß" then 'ss'
        end
      end

      #replace all non alphanumeric, underscore or periods with underscore
      ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'

      #convert double underscores to single
      ret.gsub! /_+/,"_"

      #strip off leading/trailing underscore
      ret.gsub! /\A[_\.]+|[_\.]+\z/,""

      self.slug = ret.downcase

    end

  end

end

ActiveRecord::Base.send :include, HasAccessRules
