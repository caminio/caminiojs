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
          optional :content
          requires :commentable_id
          requires :commentable_type
        end
      end
      post do
        begin
          parent = params.comment.commentable_type.classify.constantize.find params.comment.commentable_id
          comment = parent.comments.build( declared( params, include_missing: false )[:comment].except(:commentable_id,:commentable_type) )
          error!({ error: 'SavingFailed', details: comment.errors.full_messages}, 422) unless comment.save
          puts "HERE #{comment.inspect}"
          present :comment, comment, with: CommentEntity
        rescue
          error!({ error: 'FailedToFindParent', details: "parent type #{params.comment.commentable_type.classify} with id #{params.comment.commentable_id} not found"})
        end
      end

      #
      # PUT /:id
      #
      desc "update an existing comment"
      params do
        requires :comment, type: Hash do
          optional :title
          optional :content
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