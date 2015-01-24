Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  model: ->
    @store.find('user', clearCache: new Date())