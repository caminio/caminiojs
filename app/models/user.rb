class User < ActiveRecord::Base
  
  serialize :settings, JSON
  has_many :domains, through: :users_domains
  has_many :subscriptions
  has_many :circles

  has_secure_password

  attr_accessible :email, :password, :password_confirmation
  validates_presence_of :password, :on => :create

end
