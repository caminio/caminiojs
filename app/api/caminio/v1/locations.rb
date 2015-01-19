module Caminio

  module V1

    class Locations < Grape::API

      default_format :json
      helpers Caminio::AuthHelper

      before { authenticate! }

      #
      # GET /
      #
      get '/', root: 'locations' do
        locations = Location.all
        present :locations, locations, with: LocationEntity
      end

      #
      # GET /:id
      #
      desc "returns lineup_ensemble with :id"
      get ':id' do
        location = Location.where(id: params.id).first
        error!('NotFound',404) unless location
        present :location, location, with: LocationEntity
      end

      # POST
      params do
        requires :location, type: Hash do
          requires :title
          optional :description
          optional :street
          optional :zip
          optional :city
          optional :country_code
          optional :state
          optional :building
          optional :stair
          optional :floor
          optional :room
          optional :gkz
          optional :addition
          optional :lat
          optional :lng
          optional :url
          optional :phone
          optional :email
        end
      end
      post '/' do
        location = Location.new( declared( params )[:location] )
        error!({ error: 'SavingFailed', details: location.errors.full_messages}, 422) unless location.save
        present :location, location, with: LocationEntity
      end

      # PUT
      params do
        requires :location, type: Hash do
          optional :title
          optional :description
          optional :street
          optional :zip
          optional :city
          optional :country_code
          optional :state
          optional :building
          optional :stair
          optional :floor
          optional :room
          optional :gkz
          optional :addition
          optional :lat
          optional :lng
          optional :url
          optional :phone
          optional :email
        end
      end
      put '/:id' do
        location = Location.find params.id 
        error! "LocationNotFound", 404 unless location
        location.update_attributes( declared(params)[:location] )
        present :location, location, with: LocationEntity
      end

      #
      # DELETE /:id
      #
      formatter :json, lambda{ |o,env| "{}" }
      delete '/:id' do
        location = Location.find params.id 
        error! "LocationNotFound", 404 unless location
        error!("DeletionFailed",500) unless location.destroy
      end

    end
  end
end
