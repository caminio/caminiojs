require 'grape-swagger'

module V1

  class CaminioApi < Grape::API

    desc "caminio user and license management"
    prefix '/v1'

    default_format :json
    format :json
    helpers CoreHelper

    mount UsersApi
    mount AuthApi
    mount InitialApi

    if Rails.env != 'test'
      add_swagger_documentation mount_path: '/doc', hide_documentation_path: true
    end

  end

end
