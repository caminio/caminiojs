App.AccountsPricesRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
