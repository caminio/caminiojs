class OrganizationalUnits::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    authenticate!
    { organizational_units: current_user.organizational_units, organizational_unit_members: current_user.organizational_unit_members }
  end

  params do
    requires :plan_ids, type: Array
  end
  put '/:id/app_plans' do
    authenticate!
    ou = current_user.current_organizational_unit = current_user.organizational_units.find( headers['Ou'] )
    params[:plan_ids].each do |plan_id|
      ou.app_plans << AppPlan.find(plan_id)
    end
    error!('failed to save',500) unless ou.save
    {}
  end

end
