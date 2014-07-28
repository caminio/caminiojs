require 'securerandom'

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

  # generates a new confirmation_key and returns
  # it
  def gen_confirmation_key
    self.confirmation_key = SecureRandom.hex(64)
    self.confirmation_key_expires_at = 1.hour.from_now
    confirmation_key
  end

  # alias for `gen_confirmation_key` and invokes save!
  # will fail, if anything is wrong with saving to db
  def gen_confirmation_key!
    gen_confirmation_key
    self.save!
    confirmation_key
  end

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
      puts "INSIDEe"
      choosen_apps.each_pair do |app_id, value|
        if value.is_a?(Hash)
          value.each_pair do |model_id, access_level|
            self.app_model_user_roles.create( :app_model => model_id, :access_level => access_level, :app_id => app_id )
          end
        else
          puts "there is yes"
          puts App.find_by(id: app_id)
          models = App.find_by(id: app_id).app_plans
          models.each do |model|
            self.app_model_user_roles.create( :app_model => model.id, :access_level => Caminio::access::FULL, :app_id => app_id)
          end
        end
      end
    end

end
