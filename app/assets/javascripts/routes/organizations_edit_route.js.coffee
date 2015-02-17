Caminio.OrganizationsEditRoute = Caminio.AuthenticatedRoute.extend

  model: (params)->
    @store.find('organization',params.id)

