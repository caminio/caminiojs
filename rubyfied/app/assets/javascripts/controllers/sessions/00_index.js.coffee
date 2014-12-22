App.SessionsController = Ember.Controller.extend
  login: null
  password: null

  reset: ->
    @setProperties
      login: ''
      password: ''
      message: ''
      error: false

  actions:
    login: ->
      data = @getProperties 'login', 'password'
      controller = @
      Ember.$.post '/caminio/auth', data
        .then (response)->
          controller.authenticate(response.api_key)
        .fail (error)->
          if error.status == 401
            controller.set 'message', Em.I18n.t('invalid_username_or_password')

  authenticate: (api_key)->
    Ember.$.cookie 'caminio-session', api_key.access_token
    App.setAuthenticationBearer( api_key.access_token )
    @store.find('organizational_unit')
    @set 'currentUser', @store.find('user',
      api_key.user_id).then (user)->
        App.setAuthenticationBearer( api_key.access_token, user )
    @transitionToRoute('dashboard.index')
