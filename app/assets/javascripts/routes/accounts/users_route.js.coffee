App.AccountsUsersRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @store.find 'user'
