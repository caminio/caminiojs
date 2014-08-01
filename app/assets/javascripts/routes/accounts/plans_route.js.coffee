App.AccountsPlansRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
