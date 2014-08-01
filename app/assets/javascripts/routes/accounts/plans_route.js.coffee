App.AccountsPlansRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    controller.set('apps', controller.store.all('app'))
