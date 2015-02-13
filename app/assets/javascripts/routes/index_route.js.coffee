Caminio.IndexRoute = Caminio.AuthenticatedRoute.extend
  setupController: (controller,model)->
    @_super(controller,model)
    controller.set 'activities', @store.find 'activity'