Caminio.IndexRoute = Ember.Route.extend
   beforeModel: ->
    @transitionTo 'accounts.mine'