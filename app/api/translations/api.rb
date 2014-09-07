class Translations::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    requires :translation, type: Hash do
      requires :locale
      requires :title
      requires :subtitle
      requires :aside
      requires :aside2
      requires :aside3
      requires :content
      requires :description
      requires :keywords
    end
  end
  before { authenticate! }
  put '/:id' do
    tr = Translation.find params[:id]
    unless tr.update declared(params)[:translation]
      return error! 500, 'failed to save translation'
    end
    tr
  end

  params do
    requires :translation, type: Hash do
      requires :locale
      requires :row_id
      requires :row_type
      requires :title
      requires :subtitle
      requires :aside
      requires :aside2
      requires :aside3
      requires :content
      requires :description
      requires :keywords
    end
  end
  before { authenticate! }
  post '/' do
    if tr = Translation.create(declared(params)[:translation])
      return tr
    end
    error! 500, 'failed to create translation'
  end

end
