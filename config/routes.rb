Rails.application.routes.draw do

  mount Caminio::V1::Auth => "/api/v1/auth"
  mount Caminio::V1::Users => "/api/v1/users"
  mount Caminio::V1::Organizations => "/api/v1/organizations"

end
