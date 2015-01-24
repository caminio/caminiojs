Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  model: ->
    @store.find('user')