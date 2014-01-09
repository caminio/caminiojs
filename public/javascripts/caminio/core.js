define( function( require ){

  'use strict';
  var $ = require('jquery')
    , bootstrap = require('bootstrap');

  var caminio = window.caminio || {};

  var loader = '<div class="loader"><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /></div>';

  window.caminio = caminio;

  $('#toggle-side-panel').on('click', function(){
    $('#side-panel').toggle();
    $('body').toggleClass('side-panel-active');
  });

});
