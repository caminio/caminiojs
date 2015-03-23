class LabelEntity < Grape::Entity
        
  expose :id

  expose :created_at
  expose :updated_at
        
  expose :name
  expose :description
  expose :category
  expose :fgcolor
  expose :bgcolor
  expose :bdcolor

  # embeds_many :activities

end
