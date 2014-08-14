App.AccountsIndexRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    App.get 'currentUser'
