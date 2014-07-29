#= require jquery
#= require pace
#= require jquery.cookie
#= require bootstrap
#= require typeahead.js/dist/typeahead.bundle
#= require codemirror
#= require select2
#= require handlebars
#= require ember
#= require ember-data
#= require cldr-plurals
#= require ember-i18n
#
#= require_self
#= require ./router
#= require_tree ./locales
#= require_tree ./util
#= require_tree ./routes
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./views
#= require_tree ./controllers
#= require_tree ./components
#= require_tree ./templates

window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.ApplicationAdapter = DS.ActiveModelAdapter.extend
  host: '/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

App.ApplicationStore = DS.Store.extend
  adapter: DS.RESTAdapter.extend

App.setAuthenticationBearer = (access_token)->
  Ember.$.ajaxSetup
    headers:
      'Authorization': 'Bearer ' + access_token

# ember i18n
Ember.View.reopen Em.I18n.TranslateableAttributes

# DS.ArrayTransform = DS.Transform.extend
#   deserialize: (serialized)->
#     Ember.typeOf(serialized) == "array" ? serialized : []
#
#   serialize: (deserialized)->
#     type = Ember.typeOf(deserialized)
#     if type == 'array'
#       return deserialized
#     else if type == 'string'
#       return deserialized.split(',').map( (item)->
#         Em.$.trim(item)
#       )
#     else
#       return []

# App.register("transform:array", DS.ArrayTransform)
#
DS.ObjectTransform = DS.Transform.extend
  deserialize: (serialized)->
    return {} if Em.isNone(serialized)
    serialized

  serialize: (deserialized)->
    return {} if Em.isNone(serialized)
    deserialized


App.register("transform:object", DS.ObjectTransform)
