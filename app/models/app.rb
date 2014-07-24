class App < ActiveRecord::Base
  has_many :app_plans
  validates_presence_of :name, :path, :icon
  validates_uniquness_of :name, :path
end
