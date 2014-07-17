class Users::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    logger.info "here"
    { users: [] }
  end

  get '/:id' do
    { user: User.find_by_id(params[:id]) }
  end

end
