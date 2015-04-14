require "caminio/entity"

class CommentEntity < CaminioEntity
        
  expose :title
  expose :content

  expose :commentable_type do |comment|
    comment.commentable.class.name.underscore
  end

  expose :commentable_id do |comment|
    comment.commentable.id.to_s
  end
  
end
