App.AccountsOrganizationsRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
