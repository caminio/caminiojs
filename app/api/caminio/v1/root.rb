module Caminio

  module V1

    class Root < Grape::API

      unless Rails.env.test?

        mount Caminio::V1::Auth => "/api/v1/auth"
        mount Caminio::V1::Activities => "/api/v1/activities"
        mount Caminio::V1::Users => "/api/v1/users"
        mount Caminio::V1::ApiKeys => "/api/v1/api_keys"
        mount Caminio::V1::Groups => "/api/v1/groups"
        mount Caminio::V1::Organizations => "/api/v1/organizations"
        mount Caminio::V1::AppBills => "/api/v1/app_bills"
        mount Caminio::V1::Locations => "/api/v1/locations"
        mount Caminio::V1::Mediafiles => "/api/v1/mediafiles"
        mount Caminio::V1::Contacts => "/api/v1/contacts"
        mount Caminio::V1::Comments => "/api/v1/comments"

        add_swagger_documentation hide_format: true, hide_documentation_path: true, mount_path: '/api/v1/doc'
      end

    end

  end

end