requirejs.config({
  paths: {
    'text': '../vendor/requirejs-text/text',
    'knockout': '../vendor/knockout.js/knockout.debug',
    'jquery': '../vendor/jquery/jquery',
    'durandal':'../vendor/durandal',
    'plugins' : '../vendor/durandal/plugins',
    'transitions' : '../vendor/durandal/transitions',
    'i18next': '../vendor/i18next/i18next.amd.withJQuery-1.7.1',
    'moment': '../vendor/moment/moment',
    'data_service': '../data_service'
  },
  shim: {
    'bootstrap': {
      deps: ['jquery'],
      exports: 'jQuery'
    }
  }
});

define(function(require) {

  var app = require('durandal/app')
    , viewLocator = require('durandal/viewLocator')
    , system = require('durandal/system')
    , binder = require('durandal/binder')
    , i18n = require('i18next');

  //>>excludeStart("build", true);
  system.debug(true);
  //>>excludeEnd("build");

  app.title = 'nginios';

  app.configurePlugins({
    router:true,
    dialog: true,
    widget: true
  });

  var i18NOptions = {
    detectFromHeaders: false,
    lng: window.navigator.userLanguage || window.navigator.language || 'en',
    fallbackLng: 'en',
    ns: 'nginios',
    resGetPath: '/v1/dashboard/translations/__lng__.json',
    useCookie: false
  };

  app.start().then(function() {

    i18n.init(i18NOptions, function(t){

      binder.binding = function (obj, view) {
        $(view).i18n();
      };

      //Replace 'viewmodels' in the moduleId with 'views' to locate the view.
      //Look for partial views in a 'views' folder in the root.
      viewLocator.useConvention();

      //Show the app by setting the root view model for our application with a transition.
      app.setRoot('viewmodels/shell', 'entrance');
    });

  });
});
