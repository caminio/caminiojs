class Domain < ActiveRecord::Base
  
  serialize :settings, JSON
  has_many :users, through: :users_domains

end
