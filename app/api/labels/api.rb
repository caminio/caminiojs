class Labels::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers Caminio::API::Helpers

  params do
    optional :type
  end
  before { authenticate! }
  get '/', root: 'labels' do
    Label.joins(:row_labels).where(row_labels: { row_type: params.type })
  end

end
