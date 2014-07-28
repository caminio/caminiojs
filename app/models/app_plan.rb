class AppPlan < ActiveRecord::Base
  belongs_to :app
  has_many :translations
  validates_presence_of :app, :on => :create  
end
