class AppPlans::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json
  # formatter :json, Grape::Formatter::Rabl
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers Caminio::API::Helpers

  desc "returns available app plans for this user"
  params do 
    requires :user_id, type: Integer, desc: "user id"
  end
  get '/', root: 'app_plans' do
    authenticate!
    @user = User.find_by_id params[:user_id]
    error!("Forbidden",403) unless ( @user || @user.id == current_user.id || current_user.is_superuser? )
    app_plans(@user)
    #` apps: AppPlan.where( 
    #   "organizational_unit_app_plans.organizational_unit_id IN (?,0) OR apps.is_public = ?", 
    #   user.organizational_units.map(&:id), true)
    # .includes(:app,:organizational_unit_app_plans).references(:app,:organizational_unit_app_plans).map(&:app) 
  end

  helpers do

    def app_plans(user)
      app_plans = []
      App.where( hidden: false ).each do |app| 
        app_plans += app.app_plans.where(hidden: false)
      end
      user.organizational_units.each do |ou|
        app_plans += ou.app_plans
      end
      app_plans
    end

    def apps(user)
      apps = []
      user.organizational_units.each do |ou|
        ou.app_plans.each do |app_plan|
          apps << app_plan.app unless apps.any{ |app| app.id == app_plan.app_id }
        end
      end
      apps
    end
  end

end
