Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  mount Sessions::API => "/sessions"
  get "/" => "main#index"
end
