class OrganizationalUnits::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  get '/', root: 'organizational_units' do
    authenticate!
    current_user.organizational_units
  end

  params do
    requires :organizational_unit, type: Hash do
      requires :name
    end
  end
  post '/' do
    authenticate!
    ou = current_user.organizational_units.create declared( params )[:organizational_unit]
    return error!(ou.errors.full_messages, 422) unless ou
    ou
  end

  params do
    requires :plan_ids, type: Array
  end
  put '/:id/app_plans' do
    authenticate!
    ou = current_user.current_organizational_unit = current_user.organizational_units.find( headers['Ou'] )
    ou.app_plans.each do |plan|
      ou.app_plans.delete(plan)
    end
    params[:plan_ids].each do |plan_id|
      app_plan = AppPlan.find(plan_id)
      ou.app_plans << app_plan
    end
    ou.save
    error!('failed to save',500) unless ou.save
    {}
  end

  desc "deletes an organizational unit"
  delete '/:id' do
    authenticate!
    ou = OrganizationalUnit.find params[:id]
    return error!('not_found',404) unless ou
    return error!('cannot_delete_private_ou',409) if ou.name == 'private'
    return ou if ou.destroy
    error!('failed_to_delete',500)
  end

end
