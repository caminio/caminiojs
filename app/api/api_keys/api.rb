class ApiKeys::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  get '/:access_token' do
    { api_key: ApiKey.find_by_access_token(params[:access_token]) }
  end

end
