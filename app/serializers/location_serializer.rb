class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :street, :zip, :city, :country_code, :state,
    :building, :stair, :floor, :room, :gkz, :addition, :lat, :lng, :url, :phone, :email
end
