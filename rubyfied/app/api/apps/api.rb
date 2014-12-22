class Apps::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  before { authenticate! }
  helpers Caminio::API::Helpers

  desc "returns available apps"
  get '/', root: 'apps' do
    if params.user_id
      return current_organizational_unit.apps
    end
    App.where({})
  end

end
