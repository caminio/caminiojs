define( function( require ){

  'use strict';
  var $ = require('jquery');

  var nginios = window.nginios || {};

  var loader = '<div class="loader"><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /><div class="circle" /></div>';

  window.nginios = nginios;

  $('#toggle-side-panel').on('click', function(){
    $('#side-panel').toggle();
    $('body').toggleClass('side-panel-active');
  });

});
