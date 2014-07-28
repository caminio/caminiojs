class App < ActiveRecord::Base
  has_many :app_plans
  has_many :app_models

  before_save :check_for_plan


  private

    def check_for_plan

      # if self.app_plans.size === 0
      #   app_plan = AppPlan.create( price: 0, app_id: self.id, visible: true )
      #   puts self.inspect
      # end

    end
end
