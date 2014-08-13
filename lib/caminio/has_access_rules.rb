
# encoding: utf-8
module HasAccessRules

  extend ActiveSupport::Concern

  module ClassMethods

    def has_access_rules(options={})

      Caminio::ModelRegistry.add self.name, options
      
      include InstanceMethods

      belongs_to :creator, class_name: 'User', foreign_key: :created_by
      belongs_to :updater, class_name: 'User', foreign_key: :updated_by
      belongs_to :deleter, class_name: 'User', foreign_key: :deleted_by

      has_many :access_rules, as: :row
      has_many :labels, through: :row_labels
      has_many :row_labels, as: :row, dependent: :delete_all

      before_validation :set_updater, on: :create
      before_validation :check_if_updater_is_set, on: :save
      before_destroy :check_if_user_can_destroy
      validate :check_if_updater_has_rights
      after_create :create_default_rule
      after_find :set_temporary_updater

      validates_presence_of :creator, :updater

      default_scope { where(deleted_at: nil) }

    end

    def new_with_user(user, attributes)
      row = self.new( attributes )
      row.creator = user 
      row.updater = user
      row
    end

    def create_with_user(user, attributes)
      row = new_with_user(user, attributes)
      row if row.save
    end

    def with_user(user)
      Thread.current.thread_variable_set(:current_user, user)
      self.includes(:access_rules).where( access_rules: { user_id: user.id })
    end

  end

  module InstanceMethods

    def check_if_user_can_destroy
      rule = access_rules.find_by( user: updater )
      can_destroy = rule && ( rule.can_delete? || rule.is_owner? ) 
      return false unless can_destroy 
      access_rules.delete_all
    end

    def share(user, rights={can_delete: false, can_write: false, can_share: false})
      puts user.current_organizational_unit.inspect
      rule = access_rules.find_by( user: updater )
      can_share = rule && ( rule.can_share? || rule.is_owner? ) 
      return false unless can_share 
      if existing_rule = access_rules.find_by( user: user )      
        existing_rule.with_user(updater).update(rights)
      else
        access_rules.create({ user: user, creator: updater, updater: updater }.merge(rights))
      end
    end

    def check_if_updater_has_rights
      return if new_record?
      rule = access_rules.find_by( user: updater )
      return errors.add( :updater, "insufficient rights") unless rule 
      return if rule.is_owner
      return errors.add( :updater, "insufficient rights") unless rule.can_write 
    end

    def check_if_updater_is_set 
      throw new StandardError( "Security Transgression" ) unless @updater_has_been_set
    end

    def create_default_rule
      user = User.find_by( :id => self.created_by )
      unit = user.current_organizational_unit || user.organizational_units.first
      self.access_rules.create(
        row_id: self.id,
        row_type: self.class.name,
        user_id: self.created_by,
        organizational_unit: unit,
        is_owner: true,
        created_by: self.created_by,
        updated_by: self.created_by
      )
    end

    def set_temporary_updater
      with_user( Thread.current.thread_variable_get(:current_user) )
      Thread.current.thread_variable_set(:current_user, nil)
    end

    def set_updater
      self.updated_by = self.created_by
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

      def with_user( user )
        self.updater = user 
        @updater_has_been_set = true
        self
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

ActiveRecord::Base.send :include, HasAccessRules

