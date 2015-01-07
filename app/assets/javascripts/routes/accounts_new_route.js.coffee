Caminio.AccountsNewRoute = Caminio.AuthenticatedRoute.extend
  model: ->
    org = @controllerFor('application').get('currentOrganization')
    @store.createRecord('user', { organization: org })
