App.AccountsInvoicesRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    route = @
