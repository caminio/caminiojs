requirejs.config({
  paths: {
    'text': '../vendor/requirejs-text/text',
    'bootstrap': '../vendor/bootstrap/bootstrap',
    'knockout': '../vendor/knockout.js/knockout.debug',
    'knockout-validation': '../vendor/knockout.js/knockout.validation',
    'jquery': '../vendor/jquery/jquery',
    'durandal':'../vendor/durandal',
    'plugins' : '../vendor/durandal/plugins',
    'transitions' : '../vendor/durandal/transitions',
    'i18next': '../vendor/i18next/i18next.amd.withJQuery-1.7.1',
    'select2': '../vendor/select2/select2',
    'moment': '../vendor/moment/moment',
    'data_service': '../data_service',
    'nginios': '../nginios'
  },
  shim: {
    'jquery': {
      exports: 'jQuery'
    },
    'knockout-validation': {
      deps: [ 'knockout' ],
      exports: 'ko'
    },
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
    , nginiosHelper = require('nginios/helper')
    , nginiosCore = require('nginios/core')
    , i18n = require('i18next');

  //>>excludeStart("build", true);
  system.debug(true);
  //>>excludeEnd("build");

  app.title = 'camin.io';

  app.configurePlugins({
    router: true,
    widget: true
  });

  // a message implementation
  app.notify = nginiosHelper.notify;

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
