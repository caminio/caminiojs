Caminio.OrganizationsEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: (params)->
    @store.find('organization',params.id)

