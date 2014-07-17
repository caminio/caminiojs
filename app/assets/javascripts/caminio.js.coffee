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

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: '/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

# App.ApplicationAdapter = DS.RESTAdapter.extend

App.ApplicationStore = DS.Store.extend
  adapter: DS.RESTAdapter.extend

App.setAuthenticationBearer = (api_key)->
  Ember.$.ajaxSetup
    headers:
      'Authorization': 'Bearer ' + api_key.access_token

# ember i18n
Ember.View.reopen Em.I18n.TranslateableAttributes
