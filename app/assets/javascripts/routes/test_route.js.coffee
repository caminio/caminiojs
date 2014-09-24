App.TestRoute = Em.Route.extend
  model: ->
    @store.find('user')
      .then (users)->
        u = users.get('firstObject')
