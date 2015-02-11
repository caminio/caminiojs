Caminio.UsersEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  requireAdmin: true
  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'users.index'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'account.manage'
    
  model: (params)->
    @store.find 'user', params.id