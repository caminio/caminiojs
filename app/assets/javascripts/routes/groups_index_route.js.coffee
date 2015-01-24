Caminio.GroupsIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  model: ->
    @store.find('group', clearCache: new Date())