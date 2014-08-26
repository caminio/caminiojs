App.AccountsPlansRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    controller.set('myPlans', App.get('currentOu.app_plans'))

    if App.get('currentOu.app_plans.length') < 1
      @render 'accounts/available_plans', into: 'application', outlet: 'modal'

    controller.set('apps',  @store.all('app'))
    controller.get('apps').forEach (app)->
      app.set('current_plan', app.get('app_plans.firstObject'))
    
  actions:

    willTransition: (transition)->
      currentUser = @.controllerFor('sessions').get('currentUser')
      if !@get('forceTransition') && currentUser.get('isDirty')
        @set('previousTransition', transition)
        transition.abort()
        @.render 'confirm_transition', into: 'application', outlet: 'modal', (proceed)->
          if proceed
            transition.retry()

    confirmTransition: (proceed)->
      if proceed
        currentUser = @store.getById('user', @.controllerFor('sessions').get('currentUser.id'))
        console.log currentUser
        currentUser.reload()
        @set('forceTransition', true)
        @get('previousTransition').retry()
        @disconnectOutlet outlet: 'modal', parentView: 'application'
