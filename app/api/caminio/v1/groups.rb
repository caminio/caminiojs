
module Caminio

  module V1

    class Groups < Grape::API

      default_format :json
      format :json
      helpers Caminio::UsersHelper


      helpers Caminio::ApplicationHelper
      helpers Caminio::AuthHelper

      #
      # GET /
      #
      desc "lists all groups for current_user"
      get do
        authenticate!
        groups = Group.where organization: current_organization
        present :groups, groups, with: GroupEntity
      end

      #
      # POST /
      #
      desc "creates a new group for this user / organization"
      params do
        requires :group, type: Hash do
          requires :name
        end
      end
      post do
        authenticate!
        require_admin!
        group = Group.new name: params.group.name, 
                            organization: current_organization, 
                            users: [ current_user ]
        return error!({ error: 'FailedToCreate', details: group.errors.full_messages }) unless group.save
        present :group, group
      end

      #
      # GET /:id
      #
      desc "returns the group for given id"
      get ':id' do
        authenticate!
        error("InsufficientRights",403) unless current_user.groups.find( params.id )
        org = Group.find params.id
        present :group, org, with: GroupEntity
      end

    end

  end

end
