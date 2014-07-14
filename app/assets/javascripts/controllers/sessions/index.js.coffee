App.SessionsController = Ember.Controller.extend
  email: null
  password: null

  reset: ->
    @setProperties
      login: ''
      password: ''
      errorMessage: ''

  actions:
    login: ->
      data = @getProperties 'email', 'password'
      controller = @
      Ember.$.post '/caminio/sessions', data
        .then (response)->
          Ember.$.cookie 'caminio-session', response.api_key.access_token
          controller.set 'currentApiKey', response.api_key
          controller.set 'currentUser', controller.store.find('user',
            response.api_key.user_id)
          Ember.$.ajaxSetup
            headers:
              'Authorization': 'Bearer ' + response.api_key.access_token
        .fail (error)->
          if error.status == 401
            alert('wrong username or password')

    logout: ->
      controller = @
      Ember.$.ajax url: "/caminio/sessions/#{@get('currentApiKey.id')}",
        type: 'delete'
        .then (response)->
          Ember.$.removeCookie 'caminio-session'
          Ember.$.ajaxSetup
            headers:
              'Authorization': 'Bearer none'
          controller.set 'currentApiKey', null
          controller.set 'currentUser', null

