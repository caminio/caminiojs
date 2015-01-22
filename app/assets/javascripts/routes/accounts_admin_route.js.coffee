Caminio.AccountsAdminRoute = Caminio.AuthenticatedRoute.extend
  setupController: (controller)->
    @store.find('user')
    .then (users)=>
      controller.set('users',users)
      @store.find('group')
      .then (groups)=>
        controller.set('groups',groups)
        @store.find('organization')
        .then (organizations)=>
          controller.set('organization')


