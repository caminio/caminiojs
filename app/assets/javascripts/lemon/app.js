(function(){

  'use strict';

  var App = window.App = Em.Application.create();
  
  App.ApplicationAdapter = DS.RESTAdapter.extend({
    host: '<%= request.protocol %><%= request.host %><%= request.port %>/caminio',
    headers: {
      'X-CSRF-Token': '<%= _csrf %>',
      // 'sideload': true,
      // 'namespaced': true
    }
  });

})();
