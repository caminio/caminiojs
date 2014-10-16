class AccessRules::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers
  formatter :json, Grape::Formatter::ActiveModelSerializers

  before{ authenticate! }

  params do
    requires :access_rule, type: Hash do
      requires :can_write, type: Boolean
      requires :can_share, type: Boolean
      requires :can_delete, type: Boolean
      requires :user_id
      requires :app_id
      requires :organizational_unit_id
    end
  end
  post '/' do
    error!('not found',404) unless user = User.where( id: params.access_rule.user_id ).first
    # error!('insufficient rights',403) unless current_user.access_rules.where( app_id: BSON::ObjectId.from_string(params.access_rule.app_id), can_share: true ).first
    user.access_rules.create declared(params)[:access_rule]
  end

  params do
    requires :access_rule, type: Hash do
      requires :can_write, type: Boolean
      requires :can_share, type: Boolean
      requires :can_delete, type: Boolean
    end
  end
  put '/:id' do
    error!('access rule not found', 404) unless access_rule = AccessRule.where( id: params.id ).first
    # error!('insufficient rights',403) unless current_user.access_rules.where( app: access_rule.app, can_share: true ).first
    error!('failed to remove', 500) unless access_rule.update declared(params)[:access_rule]
    access_rule.reload
  end

  post '/repair' do
    error!('forbidden',403) unless current_organizational_unit.users.first.id == current_user.id
    current_organizational_unit.app_plans.each do |app_plan|
      app = app_plan.app
      current_user.access_rules.where(app: app, organizational_unit: current_organizational_unit).destroy
      AccessRule.create user: current_user,app: app, organizational_unit: current_organizational_unit, can_write: true, can_share: true, can_delete: true
    end
    {} if current_user.save
  end

  delete '/:id' do
    error!('access rule not found', 404) unless access_rule = AccessRule.where( id: params.id ).first
    error!('insufficient rights',403) unless current_user.access_rules.where( app: access_rule.app, can_share: true ).first
    error!('failed to remove', 500) unless access_rule.destroy
    {}
  end

end
