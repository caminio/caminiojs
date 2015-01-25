
module Caminio

  module V1

    class Groups < Grape::API

      default_format :json
      format :json
      helpers Caminio::UsersHelper


      helpers Caminio::ApplicationHelper
      helpers Caminio::AuthHelper

      helpers do
        def get_group
          group = Group.find_by id: params.id
          return error!('NotFound',404) unless group.users.include? current_user
          group
        end
      end

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
        present :group, group, with: GroupEntity
      end

      #
      # PUT /
      #
      desc "updates a group"
      params do
        requires :group, type: Hash do
          requires :name
          optional :color
        end
      end
      put ':id' do
        authenticate!
        require_admin!
        group = get_group
        group.update_attributes declared(params)[:group]
        present :group, group, with: GroupEntity
      end

      #
      # GET /:id
      #
      desc "returns the group for given id"
      get ':id' do
        authenticate!
        present :group, get_group, with: GroupEntity
      end

    end

  end

end
