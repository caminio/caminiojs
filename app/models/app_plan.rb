class AppPlan < ActiveRecord::Base
  belongs_to :app
  has_many :translations
end
