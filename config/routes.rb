Caminio::Engine.routes.draw do
  mount Users::API => "/users"
  get "/" => "main#index"
end
