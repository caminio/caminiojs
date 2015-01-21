Caminio.AccountsGroupsRoute = Caminio.AuthenticatedRoute.extend
  model: ->
    @controllerFor('application').get('currentUser')

  setupController: (controller,model)->
    @store.find('group')
    .then (groups)->
      controller.set('groups', Em.A(groups))
