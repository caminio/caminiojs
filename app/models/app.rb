class App < ActiveRecord::Base
  has_many :app_plans
  has_many :app_models

  has_translations
end
