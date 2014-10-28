App.AccountsApiRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @store.find 'api_key', permanent: true
