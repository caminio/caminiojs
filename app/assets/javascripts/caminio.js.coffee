#= require pace_options
#= require 3rd/pace.min
#= require jquery2
#= require handlebars
#= require ember
#= require ember-data
#= require 3rd/bootstrap.min
#= require 3rd/ember-animate
#= require 3rd/i18n
#= require 3rd/i18n-plurals
#= require 3rd/moment
#= require 3rd/moment.de
#= require 3rd/jquery.cookie
#= require 3rd/ember-local-storage
#= require 3rd/jquery.noty
#= require 3rd/jquery.noty.theme.top-right
#= require 3rd/selectize
#= require noty_options
#= require_tree ./locales
#= require_self
#= require caminio-ui

#= require ./store
#= require_tree ./templates
#= require_tree ./helpers
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./components
#= require_tree ./routes
#= require ./router

window.Caminio = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_BINDINGS: true
  LOG_VIEW_LOOKUPS: true
  LOG_STACKTRACE_ON_DEPRECATION: true
  LOG_VERSION: true
  debugMode: true

Caminio.set('apiHost', '/api/v1')
