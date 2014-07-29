Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  mount OrganizationalUnits::API => "/organizational_units"
  mount ApiKeys::API => "/api_keys"
  mount Sessions::API => "/sessions"
  get "/" => "main#index"
end
