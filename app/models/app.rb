class App < ActiveRecord::Base
  has_many :app_plans
  has_many :app_model
end
