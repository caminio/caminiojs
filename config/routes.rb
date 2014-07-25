Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  mount ApiKeys::API => "/api_keys"
  mount Sessions::API => "/sessions"
  get "/" => "main#index"
end
