Caminio.GroupsIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'accounts.admin'
    @controllerFor('application').set 'newBtnLink', 'groups.new'
    @controllerFor('application').set 'newBtnLinkHint', 'group.create_new'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'groups.manage'

  model: ->
    @store.find('group', clearCache: new Date())