module Caminio

  module V1

    class Activities < Grape::API
      
      default_format :json
      format :json
      helpers Caminio::ApplicationHelper
      helpers Caminio::AuthHelper

      #
      # GET /
      #
      desc "lists all api keys"
      get do
        authenticate!
        present :activities, current_organization.activities.desc(:created_at).limit(10), with: ActivityEntity
      end
      
    end
  end
end