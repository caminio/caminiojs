class GroupEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :created_at
  expose :color
  expose :user_ids

end
