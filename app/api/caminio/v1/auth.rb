module Caminio

  module V1

    class Auth < Grape::API

      default_format :json
      format :json

      helpers Caminio::AuthHelper

      # ============================================================
      # GET

      desc "returns a request token"
      get "request_token" do
        authenticate!
        @token.request_tokens.each do |t|
          t.destroy unless t.expires_at > Time.now
        end
        token = @token.request_tokens.create
        present :request_token, token, with: RequestTokenEntity
      end

      # ============================================================
      # POST
      desc "authenticates a user"
      params do
        requires :login, desc: "email address or username accepted"
        requires :password, desc: "the user's password"
      end
      post do
        api_key = authenticate_user
        Activity.create name: 'activity.logged_in'
        present :api_key, api_key, with: ApiKeyEntity
      end

      delete do
        authenticate!
        Activity.create name: 'activity.logged_out'
        ApiKey.where( user_id: current_user.id, permanent: false ).delete_all
        {}
      end
        
    end

  end

end
