Caminio.AccountsSettingsRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  setupController: (controller,model)->
    @_super controller, model
    controller.set 'loadingUsers', true
    controller.set 'loadingGroups', true
    @store.find('organization')
      .then (organizations)=>
        controller.set('organizations',organizations)
        @store.find('user', clearCache: new Date() )
          .then (users)=>
            controller.set 'users', users
            controller.set 'loadingUsers', false
            @store.find('group', clearCache: new Date() )
            .then (groups)=>
              controller.set 'groups', groups
              controller.set 'loadingGroups', false


