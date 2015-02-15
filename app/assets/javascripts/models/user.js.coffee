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
  role_name:        DS.attr 'string', default: 'user'
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
      @set 'settings', JSON.parse(value)
    JSON.stringify @get('settings'), null, 2
  ).property 'settings'
  app_roles:             DS.hasMany 'app_roles'

Caminio.UserAdapter = Caminio.ApplicationAdapter.extend()
