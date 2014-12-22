#= require 3rd/pace.min
#= require 3rd/jquery-2.1.1.debug
#= require handlebars
#= require 3rd/ember.debug
#= require 3rd/ember-data.debug
#= require 3rd/ember-animate
#= require 3rd/i18n
#= require 3rd/i18n-plurals
#= require 3rd/moment
#= require 3rd/moment.de
#= require 3rd/jquery.cookie
#= require 3rd/ember-local-storage
#= require_tree ./locales
#= require_self
#= require caminio-ui
#= require caminio-accounts

window.Caminio = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_BINDINGS: true
  LOG_VIEW_LOOKUPS: true
  LOG_STACKTRACE_ON_DEPRECATION: true
  LOG_VERSION: true
  debugMode: true

Caminio.set('apiHost', '/api/v1')
