Caminio.AccountsAdminRoute = Caminio.AuthenticatedRoute.extend
  model: ->
    @store.find('user')
