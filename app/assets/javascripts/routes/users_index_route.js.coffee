Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  
  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'rootLevel', true
    @controllerFor('application').set 'newBtnLink', 'users.new'
    @controllerFor('application').set 'newBtnLinkHint', 'account.create_account'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'account.manage'

  model: ->
    @store.find('user', clearCache: new Date())