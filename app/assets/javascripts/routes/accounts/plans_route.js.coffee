App.AccountsPlansRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    route = @
    controller.store.find('app_plan', user_id: model.id)
      .then (app_plans)->
        controller.set('availableApps',  controller.store.all('app'))
        controller.set('myPlans', model.get('current_organizational_unit.app_plans'))

        if model.get('current_organizational_unit.app_plans.length') < 1
          route.render 'accounts/available_plans', into: 'application', outlet: 'modal'
        
        controller.get('availableApps').forEach (app)->
          app.set('current_plan', app.get('app_plans.firstObject'))
