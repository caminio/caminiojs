class ApiKeys::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    requires :access_token
  end
  get '/:access_token' do
    if api_key = ApiKey.where(access_token: params.access_token).gt(expires_at: Time.now).first
      return api_key
    end
    error! 'Unauthorized', 401
  end

end
