(function(){

  'use strict';

  var App = Ember.Application.create({
    currentPath: ''
  });

  
  // restful datastore
  App.Store = DS.Store.extend({
    revision: 1
  });

  DS.RESTAdapter.reopen({
    host: remoteHost,
    namespace: remoteNamespace
  })

  window.App = App;

  App.ApplicationController = Ember.Controller.extend({

    init: function(){
      var self = this;
      // get app list
      $.getJSON('/nginios/apps/list')
      .done( function( app_list ){

        // get translations
        $.getJSON( '/nginios/i18n_translations', function(resources){
          $.i18n.init({
            fallbackLng: 'en',
            ns: 'nginios',
            useCookie: false,
            detectLngFromHeaders: false,
            resStore: resources
          }, function(){
            return self.set('apps', app_list);
          });
        });
      });
    },
    updateCurrentPath: function(){
      App.set('currentPath', this.get('currentPath'));
    }.observes('currentPath')
  });

  App.ready( function(){
    console.log('here');
    $('#side-panel a[data-name='+controllerNameWithoutNS+']').closest('li').addClass('active');
  });

  // execute this after the view has been rendered
  // for some reason, handlebars still seems to take a while
  // to really have the data- attributes attached
  App.DefaultView = Ember.View.extend({
    didInsertElement: function(){
      this._super();
      setTimeout( function(){
        $('#side-panel a[data-name='+controllerNameWithoutNS+']').closest('li').addClass('active');
      },100);
    }
  })


})();
