class User < ActiveRecord::Base
  
  serialize :settings, JSON
  has_many :domains, through: :users_domains
  has_many :subscriptions
  has_many :circles

  has_many :api_keys
  has_many :organizational_units, through: :organizational_unit_members
  has_many :organizational_unit_members

  has_secure_password

  validates_presence_of :password, :on => :create  
  validates_presence_of :email, :on => :create

  before_create :check_organizational_unit

  private

    def check_organizational_unit 
      return if self.organizational_units.size > 0
      self.organizational_units.build( :name => "private" )
    end

end
