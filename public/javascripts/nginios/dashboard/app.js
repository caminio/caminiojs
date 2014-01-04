(function(){

  'use strict';

  var App = Ember.Application.create();

  // using fixtures
  App.ApplicationAdapter = DS.FixtureAdapter.extend();
  window.App = App;
  
  App.ApplicationController = Ember.Controller.extend({
    init: function(){
            var self = this;
            return $.getJSON('/nginios/apps/list')
            .done( function( app_list ){
              return self.set('apps', app_list);
            });
          }
  });

  App.Router.map( function(){
    this.resource('dashboard', { path: '/' });
  });

  App.DashboardRoute = Ember.Route.extend({
    model: function(){
              return [{name:'test'}];
           }
  });

  registerHbs('dashboard', 'dashboard', 'id');

})();
