App.AccountsUsersNewRoute = App.ApplicationRoute.extend
  auth: true

  model: ->
    @store.createRecord 'user'

  setupController: (controller,model)->
    @_super(controller,model)
    App.get('currentOu.app_plans').forEach (app_plan)->
      app_plan.get('app.app_models').forEach (appModel)->
        role = controller.store.createRecord('app_model_user_role', app_model: appModel, user: model)
        model.get('app_model_user_roles').pushObject( role )

  actions:
    willTransition: (transition)->
      if @get('controller.content.isNew')
        @get('controller.content').destroyRecord()
      true

