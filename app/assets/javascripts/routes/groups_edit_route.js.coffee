Caminio.GroupsEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: (params)->
    @store.find('group',params.id)

