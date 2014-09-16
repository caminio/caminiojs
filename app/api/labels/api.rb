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

end
