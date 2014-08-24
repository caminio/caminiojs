App.AccountsUsersEditRoute = App.ApplicationRoute.extend
  auth: true
  model: (param)->
    @store.find 'user', param.id
  setupController: (controller,model)->
    @_super(controller,model)
    App.get('currentOu.app_plans').forEach (app_plan)->
      app_plan.get('app.app_models').forEach (appModel)->
        skip = false
        model.get('app_model_user_roles').forEach (ur)->
          skip = true if ur.get('app_model.id') == appModel.get('id')
        unless skip
          role = controller.store.createRecord('app_model_user_role', app_model: appModel, user: model)
          model.get('app_model_user_roles').pushObject( role )

