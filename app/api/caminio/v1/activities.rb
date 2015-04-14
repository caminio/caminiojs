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
      desc "lists all activities for given activitable type. If no type is given, all current_organization acitvities are listed (limit 10)"
      params do
        optional :activitable_type, type: String
        optional :activitable_id, type: String
        optional :limit, type: Fixnum, default: 10
      end
      get do
        authenticate!
        if params.activitable_type
          activities = params.activitable_type.classify.constantize.where activitable_id: params.activitable_id
        else
          activities = current_organization.activities
        end
        activities = activities.desc(:created_at).limit(params.limit)
        present :activities, activities, with: ActivityEntity
      end
      
    end
  end
end