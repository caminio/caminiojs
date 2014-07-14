#= require jquery
#= require jquery.cookie
#= require bootstrap
#= require handlebars
#= require ember
#= require ember-data
#
#= require_self
#= require_tree ./routes
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./templates

window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: '<%= request.protocol %><%= request.host %><%= request.port %>/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

App.Router.map ->
  @route 'index', path: '/'
  @resource 'sessions', ->
    @route 'new'

App.ApplicationAdapter = DS.RESTAdapter.extend

