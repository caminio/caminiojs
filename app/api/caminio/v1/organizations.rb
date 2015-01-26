
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
        organizations = current_user.organizations
        organizations = Organization.where({}) if current_user.is_superuser?
        present :organizations, organizations, with: OrganizationEntity
      end

      #
      # POST /
      #
      params do
        requires :organization, type: Hash do
          requires :name
        end
      end
      desc "create a new organization with current_user as owner"
      post do
        authenticate!
        if Organization.where( name: params.organization.name ).count > 0
          return error!({ error: 'OrganizationExists', details: params.organization.name },409)
        end
        unless org = current_user.organizations.create(declared(params)[:organization])
          return error!({ error: 'ValidationError', details: org.errors.full_messages }, 422)
        end
        present :organization, org, with: OrganizationEntity
      end

      #
      # PUT /
      #
      params do
        requires :organization, type: Hash do
          requires :name
          optional :fqdn
          optional :user_quota
        end
      end
      desc "update organization attributes"
      put ':id' do
        authenticate!
        org = Organization.where({ name: params.organization.name })
        if org.id != params.organization.id && org.count > 0
          return error!({ error: 'OrganizationExists', details: params.organization.name },409)
        end
        org = current_user.organizations.find params.id
        return error!('NotFound',404) unless org
        params.organization.user_quota = org.user_quota unless current_user.is_superuser?
        org.update_attributes( declared(params)[:organization] )
        unless org.save
          return error!({ error: 'ValidationError', details: org.errors.full_messages }, 422)
        end
        present :organization, org, with: OrganizationEntity
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
