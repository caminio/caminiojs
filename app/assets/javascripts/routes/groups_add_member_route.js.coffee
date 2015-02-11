Caminio.GroupsAddMemberRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'groups.index'
    @controllerFor('application').set 'newBtnLink', 'groups.new'
    @controllerFor('application').set 'newBtnLinkHint', 'group.create_new'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'groups.manage'

  model: (params)->
    @store.find('group',params.id)


