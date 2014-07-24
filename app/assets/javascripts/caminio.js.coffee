#= require jquery
#= require jquery.cookie
#= require bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require cldr-plurals
#= require ember-i18n
#
#= require_self
#= require ./router
#= require_tree ./locales
#= require_tree ./routes
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./templates

window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.ApplicationAdapter = DS.ActiveModelAdapter.extend
  host: '/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

App.ApplicationStore = DS.Store.extend
  adapter: DS.RESTAdapter.extend

# App.ApplicationSerializer = DS.ActiveModelSerializer.extend
#   typeForRoot: (root)->
#     camelized = Ember.String.camelize(root)
#     Ember.String.singularize(camelized)
#   serializeIntoHash: (data, type, record, options)->
#     root = Ember.String.decamelize(type.typeKey)
#     data[root] = @.serialize(record, options)

App.setAuthenticationBearer = (api_key)->
  Ember.$.ajaxSetup
    headers:
      'Authorization': 'Bearer ' + api_key.access_token

# ember i18n
Ember.View.reopen Em.I18n.TranslateableAttributes
