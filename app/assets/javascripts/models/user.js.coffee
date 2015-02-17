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
  hasName: (->
    !Em.isEmpty(@get('firstname')) || !Em.isEmpty(@get('lastname'))
  ).property 'firstname', 'lastname'
  fullName: ((key,value,prevValue)->
    if arguments.length > 1
      arr = value.split(' ')
      @set 'firstname', arr[0..arr.length-2].join(' ')
      @set 'lastname', arr[arr.length-1] if arr.length > 1
    str = ''
    str += @get('firstname') unless Em.isEmpty( @get 'firstname' )
    str += ' ' if str.length > 0 && !Em.isEmpty( @get 'lastname' )
    str += @get('lastname') unless Em.isEmpty( @get 'lastname' )
    str
  ).property 'firstname', 'lastname'
  role_name:        DS.attr 'string', default: 'user'
  availableRoleNames: Em.A([
    Em.Object.create(label: 'roles.user', id: 'user'),
    Em.Object.create(label: 'roles.editor', id: 'editor'),
    Em.Object.create(label: 'roles.admin', id: 'admin')])
  locale:           DS.attr 'string', default: Em.I18n.locale
  username:         DS.attr 'string'
  superuser:        DS.attr 'boolean'
  suspended:        DS.attr 'boolean'
  firstname:        DS.attr 'string'
  lastname:         DS.attr 'string'
  email:            DS.attr 'string'
  password:         DS.attr 'string'
  # api_keys:         DS.hasMany 'api_key'
  organization:     DS.belongsTo 'organization'
  organizations:    DS.hasMany 'organizations'
  groups:           DS.hasMany 'groups'
  admin:            DS.attr 'boolean', default: false
  editor:           DS.attr 'boolean', default: false
  created_at:       DS.attr 'date'
  updated_at:       DS.attr 'date'
  last_login_at:    DS.attr 'date'
  last_request_at:  DS.attr 'date'
  settings:         DS.attr 'object'
  settingsStr:      ((key,value,prevVal)->
    if arguments.length > 1
      try
        @set 'settings', JSON.parse(value)
      catch e
        console.log e
    JSON.stringify @get('settings'), null, 2
  ).property 'settings'
  app_roles:             DS.hasMany 'app_roles'
  
  apps: (->
    @get('organization.app_plans')
  ).property 'organization'

  setLang: ->
    window.LANG = @get('locale')
    Ember.$.cookie('locale', @get('locale'))
    Ember.I18n.locale = window.LANG
    Ember.I18n.translations = Ember.I18n.availableTranslations[window.LANG]


Caminio.UserAdapter = Caminio.ApplicationAdapter.extend()
