class AppPlanEntity < Grape::Entity
  
  expose :id
  expose :app_name
  expose :subscription_ends_at
  expose :price
  expose :currency

end
