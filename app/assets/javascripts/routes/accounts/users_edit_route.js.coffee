App.AccountsUsersEditRoute = App.ApplicationRoute.extend
  auth: true
  model: (param)->
    @store.find 'user', param.id
