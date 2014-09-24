class Mediafiles::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json
  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  params do
    requires :file
    requires :parent_id
    requires :parent_type
  end
  post '/' do
    authenticate!
    mf = Mediafile.new parent_id: params.parent_id, parent_type: params.parent_type.camelize
    mf.file = params.file
    mf if mf.save
  end

end
