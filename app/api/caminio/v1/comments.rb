module Caminio

  module V1

    class Comments < Grape::API

      default_format :json
      helpers Caminio::AuthHelper
      # helpers CommentHelper

      before { authenticate! }

      #
      # GET /
      #
      desc "lists all comments"
      get '/' do
        present :comments, Comment.all, with: CommentEntity
      end

      #
      # GET /:id
      #
      desc "returns comment with :id"
      get '/:id' do
        comment = Comment.find params.id
        error!('NotFound',404) unless comment
        present :comment, comment, with: CommentEntity
      end

      #
      # POST /
      #
      desc "create a new comment"
      params do
        requires :comment, type: Hash do
          optional :title
          optional :description
        end
      end
      post do
        comment = Comment.new( declared( params )[:comment] )
        error!({ error: 'SavingFailed', details: comment.errors.full_messages}, 422) unless comment.save
        present :comment, comment, with: CommentEntity
      end

      #
      # PUT /:id
      #
      desc "update an existing comment"
      params do
        requires :comment, type: Hash do
          optional :title
          optional :description
        end
      end
      put '/:id' do        
        comment = Comment.find params.id
        error!('NotFound',404) unless comment
        comment.update_attributes( declared(params)[:comment] )
        present :comment, comment, with: CommentEntity
      end

      #
      # DELETE /:id
      #
      desc "delete an comment"
      formatter :json, lambda{ |o,env| "{}" }
      delete '/:id' do
        comment = Comment.find params.id
        error!('NotFound',404) unless comment
        error!("DeletionFailed",500) unless comment.destroy
      end

    end
  end
end