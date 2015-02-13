class ActivityEntity < Grape::Entity
  
  expose :id
  expose :name
  expose :created_at
  expose :created_by
  expose :item_id
  expose :item_type

end
