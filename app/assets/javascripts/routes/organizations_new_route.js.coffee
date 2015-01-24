Caminio.OrganizationsNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: ->
    @store.createRecord('organization')

