Caminio.AccountsMineRoute = Caminio.AuthenticatedRoute.extend

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'rootLevel', true

  model: (params)->
    @controllerFor('application').get('currentUser')
