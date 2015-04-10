Caminio.ApiKeysIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

Caminio.ApiKeysNewRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

  model: ->
    @store.createRecord 'api_key', organization_id: @controllerFor('application').get('currentOrganization.id')