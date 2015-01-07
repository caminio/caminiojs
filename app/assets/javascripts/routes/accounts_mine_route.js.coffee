Caminio.AccountsMineRoute = Caminio.AuthenticatedRoute.extend
  model: (params)->
    @controllerFor('application').get('currentUser')
