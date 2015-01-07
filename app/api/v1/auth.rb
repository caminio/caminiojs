module Caminio

  module API

    class Auth < Grape::API
  
      include Caminio::API::Container
      caminio_mountpoint :api
      
      helpers Caminio::AuthHelper

      version 'v1', using: :path

      namespace :auth do

         # ============================================================
        # POST
        desc "authenticates a user"
        params do
          requires :login, desc: "email address or username accepted"
          requires :password, desc: "the user's password"
        end
        post do
          present authenticate_user, with: Entities::ApiKey
        end
        
      end

    end

  end

end