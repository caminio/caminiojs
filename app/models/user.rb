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

  after_create :init_dependencies

  attr_accessor :choosen_apps

  private

    def init_dependencies
      check_organizational_unit
      set_app_model_user_roles
    end

    def check_organizational_unit 
      return if self.organizational_units.size > 0
      self.organizational_units.create( :name => "private" )
    end

    def set_app_model_user_roles
      return unless choosen_apps
      choosen_apps.each_pair do |app_id, value|
        if value.is_a?(Hash)
          value.each_pair do |model_id, access_level|
            self.app_model_user_roles.create( :app_model => model_id, :access_level => access_level, :app_id => app_id )
          end
        else
          models = App.find_by(id: app_id).app_plans
          models.each do |model|
            self.app_model_user_roles.create( :app_model => model.id, :access_level => Caminio::access::FULL, :app_id => app_id)
          end
        end
      end
    end

end
