module Caminio
  module API

    class Root < Grape::API
      
      mount Caminio::V1::Users => '/v1/users'
      mount Caminio::V1::Locations => '/v1/locations'
      mount Caminio::V1::Organizations => '/v1/organizations'
      mount Caminio::V1::Auth => '/v1/auth'
      mount Caminio::V1::Initial => '/v1/initial'

    end

  end
end
