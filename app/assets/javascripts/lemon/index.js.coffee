#= require_self
#= require_tree ./routes
#= require_tree ./models
#= require_tree ./controllers
#= require ./templates/index.hbs
#= require ./router

window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: '<%= request.protocol %><%= request.host %><%= request.port %>/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

