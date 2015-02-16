Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  
  setupController: (controller,model)->
    @_super controller, model
    controller.set 'loadingUsers', false

  model: ->
    @store
      .find('user', clearCache: new Date())
