(function(){

  'use strict';

  var App = Ember.Application.create();
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

})();
