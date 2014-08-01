class User < ActiveRecord::Base

  include ActiveModel::Serialization

  has_attached_file :avatar,
    :styles => { :thumb => "128x128!", :original => "500x500>" }
    # :default_url => "/images/:style/missing.png",
    # :path => ":rails_root/public/#{Rails.env}/avatars/:id/:style/:filename"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  serialize :settings, JSON
  has_many :domains, through: :users_domains
  has_many :subscriptions
  has_many :circles

  has_many :api_keys
  has_many :organizational_units, through: :organizational_unit_members
  has_many :organizational_unit_members
  has_many :app_model_user_roles, dependent: :delete_all
  has_many :app_models, through: :app_model_user_roles

  has_secure_password

  validates_presence_of :password, :on => :create  
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email
  validates_format_of :email, :with => /@/

  after_create :find_or_create_organizational_unit 
  before_destroy :destroy_dependencies

  attr_accessor :current_organizational_unit
  attr_accessor :organizational_unit_name

  def link_app_models(apps)
    current_organizational_unit ||= self.organizational_units.first
      apps.each_pair do |app_id, value|
        if value.is_a?(Hash)
          find_by_id(value, current_organizational_unit)
        else
          find_by_app(app_id, current_organizational_unit)
        end
      end
  end

  def attributes
    { firstname: nil,
      lastname: nil,
      email: nil,
      organizational_unit_ids: nil,
      avatar_thumb: nil,
      id: nil
    }
  end

  private

    def avatar_thumb
      avatar.url(:thumb)
    end

    def find_or_create_organizational_unit 
      return if self.organizational_units.size > 0     
      self.organizational_units.create( 
        :name => organizational_unit_name || "private", 
        :owner => self 
      )
    end

    def find_by_id(value, unit)
      value.each_pair do |model_id, access_level|
        model = AppModel.where( :id => model_id ).load.first
        self.app_model_user_roles.create( 
          :app_model => model, 
          :access_level => access_level, 
          :organizational_unit => unit
        )
      end
    end

    def find_by_app(app_id, unit) 
      models = App.find_by(id: app_id).app_models  
      models.each do |model|
        self.app_model_user_roles.create( 
          :app_model => model, 
          :access_level => Caminio::Access::FULL, 
          :organizational_unit => unit
        )
      end
    end

    def destroy_dependencies
      destroy_access_rule_items
      destroy_organizational_units
    end

    def destroy_access_rule_items
      rules = AccessRule.where( :user => self ).load()
      rules.each do |rule|
        all_rules = AccessRule.where( :row_id => rule.row_id ).load()
        item = rule[:row_type].singularize.classify.constantize.with_user(self).find(rule[:row_id])
        
        if all_rules.size == 1 && has_right(rule) 
          item.destroy
        else
          rule.with_user(self).destroy
        end
      end
    end

    def destroy_organizational_units 
      units = self.organizational_units
      units.each do |unit|
        if unit.users.size == 1
          unit.destroy
        elsif unit.owner_id == self.id
          unit.update(:suspended => true)
        end
      end
    end

    def has_right(rule)
      return true if rule.is_owner || rule.can_delete
      return false
    end

end