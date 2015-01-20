
module Caminio

  module V1

    class Organizations < Grape::API

      default_format :json
      format :json
      helpers Caminio::UsersHelper


      helpers Caminio::ApplicationHelper
      helpers Caminio::AuthHelper

      #
      # GET /
      #
      desc "lists all organizations for current_user"
      get do
        authenticate!
        present :organizations, current_user.organizations, with: OrganizationEntity
      end

      #
      # GET /:id
      #
      desc "returns the organization for given id"
      get ':id' do
        authenticate!
        error("InsufficientRights",403) unless current_user.organizations.find( params.id )
        org = Organization.find params.id
        present :organization, org, with: OrganizationEntity
      end

    end

  end

end
