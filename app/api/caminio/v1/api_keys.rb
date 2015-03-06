module Caminio

  module V1

    class ApiKeys < Grape::API
      
      default_format :json
      format :json
      helpers Caminio::ApplicationHelper
      helpers Caminio::AuthHelper
      helpers Caminio::UsersHelper

      #
      # GET /
      #
      desc "lists all api keys"
      get do
        authenticate!
        keys = ApiKey.all
        present :api_keys, keys, with: ApiKeyEntity
      end

      #
      # GET /:id
      #
      desc "returns api_key with :id"
      get ':id' do
        authenticate!
        require_admin!
        key = ApiKey.where( id: params.id, organization_id: headers['Organization-Id'] ).first
        error!('NotFound',404) unless key
        present :api_key, key, with: ApiKeyEntity
      end

      #
      # POST /
      #
      desc "create a new api_key"
      params do
        requires :api_key, type: Hash do
          optional :name
          optional :permanent
          optional :organization_id
          optional :user_id
        end
      end
      post do
        authenticate!
        require_admin!
        key = ApiKey.new( declared( params )[:api_key] )
        error!({ error: 'SavingFailed', details: key.errors.full_messages}, 422) unless key.save
        present :api_key, key, with: ApiKeyEntity
      end

      
      #
      # PUT /:id
      #
      desc "update an existing api_key"
      params do
        requires :api_key, type: Hash do
          optional :name
          optional :permanent
        end
      end
      put '/:id' do
        authenticate!
        require_admin!
        key = ApiKey.find params.id 
        key.update_attributes( declared(params)[:api_key] )
        present :api_key, key, with: ApiKeyEntity
      end

      #
      # DELETE /:id
      #
      desc "delete an existing api_key"
      formatter :json, lambda{ |o,env| "{}" }
      delete '/:id' do
        authenticate!
        require_admin!
        key = ApiKey.find params.id 
        error!("DeletionFailed",500) unless key.destroy
      end

    end

  end
end
