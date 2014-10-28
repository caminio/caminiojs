class Labels::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers Caminio::API::Helpers

  before { authenticate! }

  params do
    optional :category
    optional :organizational_unit_ids
  end
  get '/', root: 'labels' do
    q = Label.where category: params.category
    if params.organizational_unit_ids
      q = q.unscoped.where(
        access_rules: { 
          "$elemMatch" => { 
            organizational_unit_id: { 
              "$in" => params.organizational_unit_ids.map{ |ou_id| BSON::ObjectId.from_string(ou_id) }
            }
          }
        }
      )
    end
    q
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
  post '/' do
    Label.create(
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
  put '/:id' do
    label = Label.find(params.id)
    if label.update( declared(params)[:label] )
      label.reload
    end
  end

  # DELETE
  delete '/:id' do
    return error!('not found',404) unless label = Label.find(params.id)
    return error!('failed',500) unless label.destroy
    {}
  end

end
