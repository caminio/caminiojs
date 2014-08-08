class AppPlan < ActiveRecord::Base
  belongs_to :app
  has_many :organizational_unit_app_plans
  has_many :organizational_units, through: :organizational_unit_app_plans
  validates_presence_of :app, :on => :create

  has_translations

end
