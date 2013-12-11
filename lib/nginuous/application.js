var express = require('express');
var path = require('path');
var fs = require('fs');
var defaults = require('./defaults');
var Server = require('./server');
var ConnectionHandler = require('./db').ConnectionHandler;
var logger = require('./logger');

/**
 * creates the main instance
 * to run an nginuous application
 * @param {options} - options (see doc)
 * @param {function} - callback
 */
function Application( options ){

  this.environment = process.env.NODE_ENV || 'development';

  this.settings = defaults( options );
  this.readEnvironmentSettings();

  logger.init( this.settings );

  // database initialization
  this.db = new ConnectionHandler( this.settings );

  // open connection and continue
  // when done or failed
  this.db.open();

  // default setup for expressjs
  this.webSetup();

  // instanciate Server
  this.server = new Server( this.app, this.settings );
}

/**
 * default setup actions for
 * expressjs
 */
Application.prototype.webSetup = function webSetup(){
 
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

/**
 * read env.js file from application directory
 * and concatenate with settings
 *
 */
Application.prototype.readEnvironmentSettings = function readEnvironmentSettings(){
  
  var env;

  if( this.environment === 'test' )
    env = JSON.parse( fs.readFileSync( process.cwd()+'/test/env.json' ) );
  else
    env = JSON.parse( fs.readFileSync( process.cwd()+'/config/environments/'+this.environment+'.json' ) );
  for( var i in env )
    this.settings[i] = env[i];

}

module.exports = Application;
