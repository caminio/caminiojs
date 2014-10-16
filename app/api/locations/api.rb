class Locations::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers Caminio::API::Helpers

  before { authenticate! }

  get '/', root: 'locations' do
    Location.where
  end

  # POST
  params do
    requires :location, type: Hash do
      requires :title
      optional :description
      optional :street
      optional :zip
      optional :city
      optional :country_code
      optional :state
      optional :building
      optional :stair
      optional :floor
      optional :room
      optional :gkz
      optional :addition
      optional :lat
      optional :lng
      optional :url
      optional :phone
      optional :email
    end
  end
  post '/' do
    Location.create( params[:location] )
  end

  # PUT
  params do
    requires :location, type: Hash do
      optional :title
      optional :description
      optional :street
      optional :zip
      optional :city
      optional :country_code
      optional :state
      optional :building
      optional :stair
      optional :floor
      optional :room
      optional :gkz
      optional :addition
      optional :lat
      optional :lng
      optional :url
      optional :phone
      optional :email
    end
  end
  put '/:id' do
    location = Location.find(params.id)
    if location.update( declared(params)[:location] )
      location.reload
    end
  end

  # DELETE
  delete '/:id' do
    return error!('not found',404) unless location = Location.find(params.id)
    return error!('failed',500) unless location.destroy
    {}
  end

end
