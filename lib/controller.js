/* jshint node: true */
/* jshint expr: true */
'use strict';

var _         = require('lodash');

module.exports = exports = Controller;
  
function Controller( name, app ){

  this.app = app;
  this.logger = app.logger;
  this.name = name;
  this.beforeStore = {};
  this.actionsStore = {};

}

Controller.prototype.actions = function action( actCollection ){

  var controller = this;

  _.each( actCollection, function( actions, name ){
    controller.actionsStore[name] = (typeof(actions) === 'function' ? [ actions ] : actions);
  });

};

Controller.prototype.before = function before( actCollection ){

  var controller = this;

  _.each( actCollection, function( actions, name ){
    controller.beforeStore[name] = (typeof(actions) === 'function' ? [ actions ] : actions);
  });

};

Controller.prototype.hasAction = function hasAction( name ){
  return ( name in this.actionsStore );
};
