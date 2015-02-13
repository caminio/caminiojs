class ActivityEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :created_at
  expose :user_id
  expose :item_id
  expose :item_type

end
