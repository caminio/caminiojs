class User < ActiveRecord::Base
  
  serialize :settings, JSON
  has_many :domains, through: :users_domains
  has_many :subscriptions
  has_many :circles

  has_many :api_keys
  has_many :organizational_units, through: :organizational_unit_members
  has_many :organizational_unit_members, dependent: :delete_all
  has_many :app_model_user_roles, dependent: :delete_all
  has_many :app_models, through: :app_model_user_roles

  has_secure_password

  validates_presence_of :password, :on => :create  
  validates_presence_of :email, :on => :create

  after_create :check_organizational_unit 
  before_destroy :destroy_dependencies

  attr_accessor :current_organizational_unit

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

  private

    def check_organizational_unit 
      return if self.organizational_units.size > 0     
      self.organizational_units.create( 
        :name => current_organizational_unit || "private", 
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
      labels = Label.with_user(self).where( creator: self ).load()
      labels.each do |label|
        access_rules = AccessRule.where( row_id: label.id ).load()
        access_rules.each do |rule|
          if access_rules.size == 1 && is_owner(rule)
            label.destroy
          elsif rule.user == self
            puts "DESTROYING"
            puts AccessRule.count
            puts rule.destroy
            puts AccessRule.count
          end
        end  
      end
    end

    def is_owner(rule)
      return true if rule.is_owner || rule.can_delete
      return false
    end

end
