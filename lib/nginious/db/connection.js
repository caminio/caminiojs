/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var mongoose = require('mongoose')
  , fs = require('fs')
  , path = require('path')
  , logger = require('../logger')
  , modelRegistry = require('./model_registry');

/**
 * default settings for a new Connection Handler
 */

var defaults = {};

// host type
defaults.type = 'mongo';

defaults.host = 'localhost';

defaults.port = 27017;

defaults.name = 'nginios_test';


/**
 * connection handler
 * starts new sql database connection using sequelizer
 *
 * options:
 * * driver [string] possible values: mysql|sqlite|postgres [default: sqlite]
 * * host [string] optional - the hostname [default: localhost)
 * * port [number] optional - the port of the host running the db server [default: null]
 * * database [string] required
 * * username [string] optional
 * * password [string] optional
 *
 */
function Connection( options ){

  this.options = {};
  for( var i in defaults )
    this.options[i] = defaults[i];

  modelRegistry.loadModels();

  if( typeof( options ) === 'object' && typeof( options.database ) === 'object' )
    for( var i in options.database )
      this.options[i] = options.database[i];
  else
    return logger.error('db', 'insufficient arguments passed for database connection. at least the database name must be given');


}

Connection.prototype.open = function openConnection( callback ){

  var connStr = 'mongodb://'+this.options.host+':'+this.options.port+'/'+this.options.name;
  mongoose.connect(connStr);

  this.connection = mongoose.connection;
  this.connection.on('error', function( err ){
    logger.error('db', 'connection to '+connStr+' failed');
    logger.error( 'db', err.toString() );
    if( typeof( callback ) === 'function' )
      callback();
  }).once('open', function(){
    logger.info('db', 'connection to '+connStr+' established');
    if( typeof( callback ) === 'function' )
      callback();
  });

}

module.exports = Connection;
