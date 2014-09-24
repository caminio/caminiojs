class ApiKeys::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers Caminio::API::Helpers

  params do
    optional :permanent, type: Boolean
  end
  get '/', root: 'api_keys' do
    authenticate!
    ApiKey.where(permanent: params.permanent)
  end

  params do
    requires :api_key, type: Hash do
      requires :name
    end
  end
  put '/:id' do
    authenticate!
    return error!('not found',404) unless api_key = ApiKey.find(params.id)
    return error!('failed to save',500) unless api_key.update_attributes name: params.api_key.name
    api_key.reload
  end

  delete '/:id' do
    authenticate!
    return error!('not found',404) unless api_key = ApiKey.find(params.id)
    return error!('failed to save',500) unless api_key.destroy
    {}
  end

  post '/' do
    authenticate!
    current_user.api_keys.create permanent: true
  end

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
