App.AccountsIndexRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
