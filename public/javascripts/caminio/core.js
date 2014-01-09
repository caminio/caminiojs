define( function( require ){

  'use strict';
  var $ = require('jquery')
    , bootstrap = require('bootstrap')
    , app = require('durandal/app');

  var caminio = window.caminio || {};

  var loader = '<div class="loader"><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /></div>';

  window.caminio = caminio;

  $('#toggle-side-panel').on('click', function(){
    $('#side-panel').toggle();
    $('body').toggleClass('side-panel-active');
  });

  moment.lang('de');

  var i18NOptions = {
    detectFromHeaders: false,
    lng: 'de',
    fallbackLng: 'de',
    ns: 'caminio',
    resGetPath: '/v1/dashboard/translations/__lng__.json',
    useCookie: false
  };

  app.title = 'camin.io';
  
  app.configurePlugins({
    router: true,
    widget: true,
    dialog: true
  });

  return {
    i18NOptions: i18NOptions
  }

});
