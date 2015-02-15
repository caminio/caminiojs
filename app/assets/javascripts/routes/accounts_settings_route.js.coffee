Caminio.AccountsSettingsRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  setupController: (controller)->
    @store.find('organization')
      .then (organizations)=>
        controller.set('organizations',organizations)
        @store.find('user', clearCache: new Date() )
          .then (users)=>
            controller.set('users',users)
            @store.find('group', clearCache: new Date() )
            .then (groups)=>
              controller.set('groups',groups)


