require 'grape-swagger'

module Caminio
  module API

    class Root < Grape::API

      desc "caminio user and license management"
      prefix '/v1'
      helpers API::Helper

      default_format :json
      format :json

      mount API::Users
      mount API::Auth
      mount API::Initial

      add_swagger_documentation mount_path: '/doc', hide_documentation_path: true

    end

  end
end
