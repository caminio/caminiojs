class ApiKeys::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  get '/:access_token' do
    if apiKey = ApiKey.where("access_token = ? AND expires_at > ?", params[:access_token], Time.now).first
      return { api_key: apiKey }
    end
    error! 'Unauthorized', 401
  end

end
