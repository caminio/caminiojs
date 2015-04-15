Caminio.IndexController = Ember.ObjectController.extend

  init: ->

    socket = new WebSocket("ws://#{location.host}/activities/#{@get('controllers.application.currentUser.id')}/#{@get('controllers.application.currentUser.organization.id')}")

    socket.onmessage = (response)=>
      jsonMsg = JSON.parse(response.data)
      if jsonMsg instanceof Array
        jsonMsg.forEach (msg)=>
          activity = Caminio.Activity.create msg.activity
          @activities.pushObject activity
      else
        activity = Caminio.Activity.create msg
        @activities.pushObject activity

    socket.onclose   = =>
      msg = Caminio.Activity.create name: 'connection_lost', created_at: new Date()
      @activities.pushObject msg

  needs: ['application']

  activities: Em.A()

  sortedActivities: (->
    a = @get('activities').sortBy('created_at')
    a.reverse()
  ).property 'activities.@each'
  