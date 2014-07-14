window.App = Ember.Application.create()

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: '<%= request.protocol %><%= request.host %><%= request.port %>/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

