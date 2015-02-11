Caminio.AccountsShowRoute = Caminio.AuthenticatedRoute.extend

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'rootLevel', true

  model: (params)->
    @store.find('user', params.id)
