App.AccountsInvoicesRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    route = @
