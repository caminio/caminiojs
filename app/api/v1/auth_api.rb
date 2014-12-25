module V1

  class AuthApi < Grape::API

    formatter :json, Grape::Formatter::ActiveModelSerializers
    helpers AuthHelper

    resource :auth do

      # ============================================================
      # POST
      desc "authenticates a user"
      params do
        requires :login, desc: "email address or username accepted"
        requires :password, desc: "the user's password"
      end
      post do
        authenticate_user
        @current_user.api_key
      end

    end

  end

end
