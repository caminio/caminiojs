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
        presetn current_organization.activities, with: ActivityEntity
      end
      
    end
  end
end