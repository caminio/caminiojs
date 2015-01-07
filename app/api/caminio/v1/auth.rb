module Caminio

  module V1

    class Auth < Grape::API

      default_format :json
      format :json

      helpers Caminio::AuthHelper

      # ============================================================
      # POST
      desc "authenticates a user"
      params do
        requires :login, desc: "email address or username accepted"
        requires :password, desc: "the user's password"
      end

      post do
        present authenticate_user, with: ApiKeyEntity
      end
        
    end

  end

end