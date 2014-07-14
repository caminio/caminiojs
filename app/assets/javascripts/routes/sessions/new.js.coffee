App.SessionsNewRoute = Ember.Route.extend
  model: ->
    @store.find('user')
  setupController: (controller, model)->
    controller.reset()
