App.AccountsUsersNewRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @store.createRecord 'user'
