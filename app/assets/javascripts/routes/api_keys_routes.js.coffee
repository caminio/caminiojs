Caminio.ApiKeysIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

Caminio.ApiKeysNewRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

  model: ->
    @store.createRecord 'api_key'

Caminio.ApiKeysEditRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

  model: (params)->
    @store.find 'api_key', params.id

