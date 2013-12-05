var express = require('express');
var path = require('path');
var fs = require('fs');
var defaults = require('./defaults');
var Server = require('./server');
var logger = require('./logger');

/**
 * creates the main instance
 * to run an nginuous application
 */
function Application( options ){
  
  this.settings = defaults( options );

  logger.init( this.settings );

  // default setup for expressjs
  this.setup();

  // instanciate Server
  this.server = new Server( this.app, this.settings );

}

/**
 * default setup actions for
 * expressjs
 */
Application.prototype.setup = function setup(){
 
  // the main express app object
  this.app = express();

  this.app.set('views', path.join(__dirname, 'views'));
  this.app.set('view engine', 'ejs');
  this.app.use(express.favicon());
  this.app.use(express.logger('dev'));
  this.app.use(express.json());
  this.app.use(express.urlencoded());
  this.app.use(express.methodOverride());
  this.app.use(this.app.router);
  this.app.use(express.static(path.join(__dirname, 'public')));

  // development only
  if( 'development' == this.app.get('env') ){
    this.app.use(express.errorHandler());
  }

}

module.exports = Application;
