class Labels::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers Caminio::API::Helpers

  params do
    optional :category
  end
  before { authenticate! }
  get '/', root: 'labels' do
    Label.where category: params.category
  end

  # POST
  params do
    requires :label, type: Hash do
      requires :name
      optional :category
      optional :fgcolor, default: '#ddd'
      optional :bgcolor, default: '#ddd'
      optional :bdcolor, default: '#ddd'
    end
  end
  before { authenticate! }
  post '/' do
    Label.create_with_user( current_user, 
                           name: params.label.name, 
                           fgcolor: params.label.fgcolor, 
                           bgcolor: params.label.bgcolor, 
                           bdcolor: params.label.bdcolor, 
                           category: params.label.category )
  end

  # PUT
  params do
    requires :label, type: Hash do
      requires :name
      optional :category
      optional :fgcolor, default: '#ddd'
      optional :bgcolor, default: '#ddd'
      optional :bdcolor, default: '#ddd'
    end
  end
  before { authenticate! }
  put '/:id' do
    Label.with_user( current_user ).find(params.id).update( declared(params)[:label] )
    Label.find(params.id)
  end

  # DELETE
  before { authenticate! }
  delete '/:id' do
    return error!('not found',404) unless label = Label.with_user( current_user ).find(params.id)
    return error!('failed',500) unless label.destroy
    {}
  end

end
