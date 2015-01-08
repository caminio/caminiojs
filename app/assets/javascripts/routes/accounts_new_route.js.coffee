Caminio.AccountsNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: ->
    org = @controllerFor('application').get('currentOrganization')
    @store.createRecord('user', { organization: org })

