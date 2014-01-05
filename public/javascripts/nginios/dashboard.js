(function(){

  'use strict';

  var App = window.App;

  App.Router.map( function(){
    this.resource('dashboard', { path: '/' });
  });

  App.DashboardRoute = Ember.Route.extend({
    model: function(){
              return [{name:'test'}];
           }
  });

})();
