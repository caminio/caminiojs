class OrganizationalUnits::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    authenticate!
    { organizational_units: current_user.organizational_units, organizational_unit_members: current_user.organizational_unit_members }
  end

end
