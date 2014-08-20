App.AccountsUsersNewRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @store.createRecord 'user'
  setupController: (controller,model)->
    @_super(controller,model)
    controller.set('plans', App.get('currentOu.app_plans'))
