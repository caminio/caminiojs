class CaminioEntity < Grape::Entity
        
  expose :id

  expose :created_at
  expose :updated_at 
  expose :created_by
  expose :created_by_api_key
  expose :updated_by

end
