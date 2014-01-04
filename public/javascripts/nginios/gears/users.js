(function(){

  'use strict';

  var App = window.App;

  App.Router.map( function(){
    this.resource('users', { path: '/users' });
  });

  App.DashboardRoute = Ember.Route.extend({
    model: function(){
              return [{name:'test'}];
           }
  });

  registerHbs('users', 'users', 'id');

})();

