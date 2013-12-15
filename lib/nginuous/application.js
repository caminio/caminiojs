/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var express = require('express')
  , path = require('path')
  , fs = require('fs')
  , defaults = require('./defaults')
  , Server = require('./server')
  , db = require('./db')
  , Connection = db.Connection
  , modelRegistry = db.modelRegistry
  , logger = require('./logger')
  , GearFactory = require('./gear_factory')
  , gearRegistry = require('./gear_registry');

/**
 * creates the main instance
 * to run an nginuous application
 * @param {options} - options (see doc)
 */
function Application( options ){

  this.environment = process.env.NODE_ENV || 'development';

  if( this.environment === 'test' )
    this.config = defaults( options );
  else
    this.config = require(process.cwd()+'/config/environments/'+this.environment)( defaults( options ) );

  logger.init( this.config );

  // initialize all gears and read in
  // their directories
  initGears( this );

  // database initialization
  this.db = new Connection( this.config );

  // open connection and continue
  // when done or failed
  this.db.open();

  // default setup for expressjs
  this.webSetup();

  // instanciate Server
  this.server = new Server( this.express, this.config );
}

/**
 * default setup actions for
 * expressjs
 */
Application.prototype.webSetup = function webSetup(){
 
  // the main express app object
  this.express = express();

  this.express.set('views', path.join(__dirname, 'views'));
  this.express.set('view engine', 'ejs');
  this.express.use(express.favicon());
  this.express.use(express.logger('dev'));
  this.express.use(express.json());
  this.express.use(express.urlencoded());
  this.express.use(express.methodOverride());
  this.express.use(this.express.router);
  this.express.use(express.static(path.join(__dirname, 'public')));

  // development only
  if( this.environment === 'development' ){
    this.express.use(express.errorHandler());
  }

}

/**
 * init gears
 * 
 * must have been registered up till now:
 * @example:
 *
 * var Gear = require('nginuous').Gear
 * var myGear = new Gear(...);
 * ...
 *
 * @api private
 */
function initGears( app ){
  app.gears = gearRegistry;
  GearFactory.app = app;
  for( var i in app.gears )
    GearFactory.process( app.gears[i] );
}

module.exports = Application;
