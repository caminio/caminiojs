module Caminio
  module API

    class Root < Grape::API
      
      mount Caminio::V1::Users => '/v1/users'
      mount Caminio::V1::ApiKeys => '/v1/api_keys'
      mount Caminio::V1::Locations => '/v1/locations'
      mount Caminio::V1::Mediafiles => '/v1/mediafiles'
      mount Caminio::V1::Organizations => '/v1/organizations'
      mount Caminio::V1::Auth => '/v1/auth'
      mount Caminio::V1::Initial => '/v1/initial'
      mount Caminio::V1::Contacts => "/v1/contacts"
      mount Caminio::V1::Comments => "/v1/comments"

    end

  end
end
