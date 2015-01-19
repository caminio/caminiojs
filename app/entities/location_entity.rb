class LocationEntity < Grape::Entity
        
  expose :id

  expose :title
  expose :description


  expose :street
  expose :zip
  expose :city
  expose :country_code
  expose :state

  expose :building
  expose :stair
  expose :floor
  expose :room
  expose :gkz
  expose :addition

  expose :lat
  expose :lng

  expose :url
  expose :phone
  expose :email

  expose :created_at
  expose :updated_at

end