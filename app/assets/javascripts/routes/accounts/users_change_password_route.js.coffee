App.AccountsUsersChangePasswordRoute = App.ApplicationRoute.extend
  auth: true
  model: (param)->
    @transitionTo('accounts.index') if param.id != App.get('currentUser.id')
    @store.find 'user', param.id
