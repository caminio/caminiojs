Caminio.AccountsShowRoute = Caminio.AuthenticatedRoute.extend
  model: (params)->
    @store.find('user', params.id)
