
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
          return error!('GroupNotFound',404) if !current_user.organization_ids.include?(group.organization_id) && !current_user.is_superuser?
          return error!('NotMemberOfGroup',400) if !group.users.include?(current_user) && !current_user.is_admin?
          group
        end
      end

      #
      # GET /
      #
      desc "lists all groups for current_user"
      get do
        authenticate!
        groups = Group.where organization_id: BSON::ObjectId.from_string(headers['Organization-Id'])
        users = []
        groups.each{ |g| g.users.each{ |u| users << u } }
        present :groups, groups, with: GroupEntity
        present :users, users, with: UserEntity
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
        current_user.groups << group
        return error!('FailedToSaveUser', 500) unless current_user.save
        present :group, group, with: GroupEntity
      end

      #
      # POST /:id/add_member
      #
      desc "add a member to this group"
      params do
        requires :email
      end
      post ':id/add_member' do
        authenticate!
        require_admin!
        group = get_group
        user = User.find_by email: params.email
        return error!('UserNotFound',404) unless user
        group.users << user
        return error!('SavingGroupFailed',500) unless group.save
        present :group, group, with: GroupEntity
        present :users, group.users, with: UserEntity
      end

      #
      # POST /:id/remove_member
      #
      desc "remove a member from this group"
      post ':id/remove_member/:user_id' do
        authenticate!
        require_admin!
        group = get_group
        user = User.find params.user_id
        return error!('UserNotFound',404) unless user
        group.users.delete user
        return error!('SavingGroupFailed',500) unless group.save
        present :group, group, with: GroupEntity
        present :users, group.users, with: UserEntity
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
        present :users, group.users, with: UserEntity
      end

      #
      # GET /:id
      #
      desc "returns the group for given id"
      get ':id' do
        authenticate!
        group = get_group
        present :group, group, with: GroupEntity
        present :users, group.users, with: UserEntity
      end

      desc "delete a group"
      delete ':id' do
        authenticate!
        require_admin!
        group = get_group
        group.users.each do |user|
          user.groups.delete group
          user.save
        end
        return error!('FailedToDelete',500) unless group.destroy
        {}
      end

    end

  end

end
