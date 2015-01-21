# common settings

# language
window.LANG = $('html').attr('lang')

Ember.I18n.locale = (Ember.$.cookie('locale') || LANG).replace(/\"/g,'')
Ember.I18n.translations = Ember.I18n.availableTranslations[Ember.I18n.locale]
# inject <attr>Translation into {{input }} helper
Ember.TextField.reopen(Ember.I18n.TranslateableAttributes)

moment.locale(LANG)

$.cookie.json = true

Caminio.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v1'
  pathForType: (type)->
    decamelized = Ember.String.decamelize(type)
    Ember.String.pluralize(decamelized)

Caminio.ApplicationStore = DS.Store.extend()

Caminio.Organization = DS.Model.extend
  name:             DS.attr 'string'
  users:            DS.hasMany 'users', inverse: 'organizations'
  
Caminio.OrganizationAdapter = Caminio.ApplicationAdapter.extend()
#
# User
#
Caminio.User = DS.Model.extend
  name:             (->
    str = ''
    str += @get('firstname') unless Em.isEmpty(@get('firstname'))
    str += ' ' if str.length > 0 && !Em.isEmpty(@get('lastname'))
    str += @get('lastname') unless Em.isEmpty(@get('lastname'))
    if str.length < 1
      str += @get('email')
    str
  ).property 'firstname', 'lastname', 'username', 'email'
  username:         DS.attr 'string'
  firstname:        DS.attr 'string'
  lastname:         DS.attr 'string'
  email:            DS.attr 'string'
  password:         DS.attr 'string'
  password_confirm: DS.attr 'string'
  api_keys:         DS.hasMany 'api_key'
  organization:     DS.belongsTo 'organization'
  organizations:    DS.hasMany 'organizations'
  groups:           DS.hasMany 'groups'
  admin:            DS.attr 'boolean', default: false
  editor:           DS.attr 'boolean', default: false
  created_at:       DS.attr 'date'
  updated_at:       DS.attr 'date'
  last_login_at:    DS.attr 'date'

Caminio.Group = DS.Model.extend
  name:       DS.attr 'string'
Caminio.GroupAdapter = Caminio.ApplicationAdapter.extend()

#
# ApiKey
#
Caminio.ApiKey = DS.Model.extend
  token:        DS.attr 'string'
  expires_at:   DS.attr 'date'
  user:         DS.belongsTo 'user', async: true
#
# Caminio.ApiKeyAdapter = DS.LSAdapter.extend
#   namespace:    'caminio-auth-keys'

Caminio.UserAdapter = Caminio.ApplicationAdapter.extend()

#
# AuthenticatedRoute
#
Caminio.AuthenticatedRoute = Ember.Route.extend
  init: ->
    @_super()
    if Ember.$.cookie('access_token')
      Ember.$.ajaxSetup
        headers: { 'Authorization': 'Bearer ' + Ember.$.cookie('access_token'), 'Organization_id': Ember.$.cookie('organization_id') }

  beforeModel: (transition)->
    userId = Ember.$.cookie('user_id')
    orgId = Ember.$.cookie('organization_id')
    unless userId
      @controllerFor('sessions').setProperties( token: null, userId: null, organizationId: null )
      return @redirectToLogin(transition)
    @store.find 'user', userId
      .then (user)=>
        @redirectToLogin(transition) unless user
        @store.find 'organization', orgId
      .catch (error)=>
        @controllerFor('sessions').reset()
        @transitionTo 'sessions'

  redirectToLogin: (transition)->
    @controllerFor('sessions').set('attemptedTransition', transition)
    @transitionTo 'sessions'

  # actions:
  #   # recover from any error that may happen during the transition to this route
  #   error: (reason, transition)->
  #     if (reason.status is 401)
  #       return @redirectToLogin(transition)
  #     console.log('unknown problem', transition, reason)

#
# SessionsRoute
#
Caminio.SessionsRoute = Ember.Route.extend
  setupController: (controller, context)->
    controller.reset()

  beforeModel: (transition)->
    return if Ember.isEmpty(@controllerFor('sessions').get('token'))
    @transitionTo 'accounts.mine'

#
# SessionsController
#
Caminio.SessionsController = Ember.Controller.extend

  login: ''
  password: ''

  availableLocales: [{ label: 'Deutsch', value: 'de'}, { label: 'English', value: 'en' }]
  selectedLocale: Ember.I18n.locale
  observeSelectedLocale: (->
    return unless @get('selectedLocale')
    Ember.$.cookie 'locale', @get('selectedLocale')
    Em.I18n.locale = @get('selectedLocale')
    location.reload()
  ).observes 'selectedLocale'

  attemptedTransition: null

  token: Ember.$.cookie('access_token')

  userId: Ember.$.cookie('user_id')

  organizationId: Ember.$.cookie('organization_id')

  tokenChanged: (->
    if Ember.isEmpty(@get('token'))
      Ember.$.removeCookie('access_token')
      Ember.$.removeCookie('user_id')
      Ember.$.removeCookie('organization_id')
    else
      Ember.$.cookie('access_token', @get('token'))
      Ember.$.cookie('user_id', @get('userId'))
      Ember.$.cookie('organization_id', @get('organizationId'))
  ).observes 'token', 'userId'

  reset: ->
    @setProperties
      login: null
      password: null
      token: null
      userId: null
      organizationId: null
    
    Ember.$.ajaxSetup
      headers: { 'Authorization': 'Bearer none', 'Organization_id': null }

Caminio.SessionsIndexController = Caminio.SessionsController.extend

  needs: ['sessions']

  actions:
  
    loginUser: ->
      data = @getProperties('login', 'password')
      attemptedTrans = @get('attemptedTransition')

      @setProperties
        login: null,
        password: null

      Ember.$.post('/api/v1/auth', data)
        .then (response)=>
          Ember.$.ajaxSetup
            headers: { 'Authorization': 'Bearer ' + response.api_key.token, 'Organization_id': response.api_key.organization_id }
          # @get('store').find('apiKey').forEach (apiKey)-> apiKey.destroyRecord()
          # key = @get('store').createRecord('apiKey', response.api_key )
          @get('controllers.sessions').set('token', response.api_key.token)
          @get('controllers.sessions').set('organizationId', response.api_key.organization_id)
          @store.find('user', response.api_key.user_id)
            .then (user)=>
              @get('controllers.sessions').set('userId', user.get('id'))
              # key.set('user', user)
              # key.save()
              
              if attemptedTrans
                attemptedTrans.retry()
                @set('attemptedTransition', null)
              else
                @transitionToRoute 'accounts.mine'
        .fail (error)->
          if error.status is 401
            alert("wrong user or password, please try again")

  
#
# ApplicationController
#
Caminio.ApplicationController = Ember.Controller.extend
  needs:  ['sessions']

  currentUser: Em.computed ->
    @store.getById 'user', @get('controllers.sessions.userId')
  .property 'controllers.sessions.userId'

  currentOrganization: Em.computed ->
    org = @store.getById 'organization', @get('controllers.sessions.organizationId')
    org
  .property 'controllers.sessions.organizationId'

  isAuthenticated: Em.computed ->
    !!@get('currentUser')
  .property 'controllers.sessions.token', 'controllers.sessions.userId'

  actions:
    logout: ->
      @get('controllers.sessions').reset()
      @transitionToRoute 'sessions'


Caminio.DestroyOnCancelMixin = Ember.Mixin.create

  actions:
    willTransition: (transition)->
      if @get('controller.content.isNew')
        @get('controller.content').destroyRecord()
      true