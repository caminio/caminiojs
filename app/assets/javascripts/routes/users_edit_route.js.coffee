Caminio.UsersEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  requireAdmin: true
  model: (params)->
    @store.find 'user', params.id