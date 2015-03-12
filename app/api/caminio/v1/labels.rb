module Caminio

  module V1

    class Labels < Grape::API

      default_format :json
      helpers Caminio::AuthHelper

      before { authenticate! }

      #
      # GET /
      #
      desc "returns lineup_ensemble with :id"
      params do
        optional :category
      end
      get '/', root: 'labels' do
        labels = Label.where category: params.category
        present :labels, labels, with: LabelEntity
      end

      #
      # GET /:id
      #
      desc "returns lineup_ensemble with :id"
      get '/:id' do
        label = Label.find params.id
        error!('NotFound',404) unless label
        present :label, label, with: LabelEntity
      end

      #
      # POST /
      #
      params do
        requires :label, type: Hash do
          requires :name
          optional :category
          optional :fgcolor, default: '#ddd'
          optional :bgcolor, default: '#ddd'
          optional :bdcolor, default: '#ddd'
        end
      end
      post '/' do
        label = Label.new( declared( params )[:label] )
        error!({ error: 'SavingFailed', details: label.errors.full_messages}, 422) unless label.save
        present :label, label, with: LabelEntity
      end

      #
      # PUT /:id
      #
      params do
        requires :label, type: Hash do
          requires :name
          optional :category
          optional :fgcolor, default: '#ddd'
          optional :bgcolor, default: '#ddd'
          optional :bdcolor, default: '#ddd'
        end
      end
      put '/:id' do
        label = Label.find params.id 
        error! "LocationNotFound", 404 unless label
        label.update_attributes( declared(params)[:label] )
        present :label, label, with: LabelEntity
      end
      
      #
      # DELETE /:id
      #
      delete '/:id' do
        label = Label.find params.id 
        error! "LocationNotFound", 404 unless label
        error!("DeletionFailed",500) unless label.destroy
      end

    end

  end

end
