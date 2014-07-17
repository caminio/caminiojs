Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  mount ApiKeys::API => "/apiKeys"
  mount Sessions::API => "/sessions"
  get "/" => "main#index"
end
