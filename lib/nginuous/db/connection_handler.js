var mongoose = require('mongoose');
var fs = require('fs');
var path = require('path');

var logger = require('../logger');

/**
 * default settings for a new Connection Handler
 */

var defaults = {};

// host name
defaults.host = 'localhost';

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
function ConnectionHandler( options ){

  this.options = {};
  for( var i in defaults )
    this.options[i] = defaults[i];

  if( typeof( options ) === 'object' && typeof( options.db ) === 'object' )
    for( var i in options.db )
      this.options[i] = options.db[i];
  else
    return logger.error('db', 'insufficient arguments passed for database connection. Missing username, password attributes');


}

ConnectionHandler.prototype.open = function openConnection( callback ){

  var connStr = 'mongodb://'+this.options.host+'/'+this.options.database;
  mongoose.connect(connStr);

  this.connection = mongoose.connection;
  this.connection.on('error', function(){
    logger.error('db', 'connection to '+connStr+' failed');
    if( typeof( callback ) === 'function' )
      callback();
  }).once('open', function(){
    logger.info('db', 'connection to '+connStr+' established');
    if( typeof( callback ) === 'function' )
      callback();
  });

}

module.exports = ConnectionHandler;
