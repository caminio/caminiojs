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
    ou.app_plans.where("app_plans.id NOT IN (?)", params[:plan_ids]).map(&:destroy)
    params[:plan_ids].each do |plan_id|
      app_plan = AppPlan.find(plan_id)
      app_plan.app.app_models.each do |app_model|
        ou.app_model_user_roles << AppModelUserRole.new(
          app_model: app_model, access_level: Caminio::Access::FULL, user: current_user
        )
      end
      ou.app_plans << app_plan
    end
    error!('failed to save',500) unless ou.save
    {}
  end

end
