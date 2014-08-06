Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  mount AppPlans::API => "/app_plans"
  mount OrganizationalUnits::API => "/organizational_units"
  mount ApiKeys::API => "/api_keys"
  mount Sessions::API => "/sessions"
  get "/" => "main#index"
end
