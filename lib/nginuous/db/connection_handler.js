
var Sequelize = require('sequelize');
var fs = require('fs');
var path = require('path');

var logger = require('../logger');

/**
 * default settings for a new Connection Handler
 */

var defaults = {};

// the driver (dialect in sequelize)
defaults.driver = 'sqlite';

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
    return logger.error('db', 'inusfficient arguments passed for database connection. Missing username, password attributes');

  var sequelizeOptions = {
    dialect: this.options.driver
  };

  if( this.options.driver === 'sqlite' ){
    sequelizeOptions.storage = this.options.database;
    if( !fs.existsSync( path.dirname( this.options.database ) ) ){
      fs.mkdirSync( path.dirname( this.options.database ) );
      logger.info('db', 'created directory '+path.dirname( this.options.database )+' as it was not existend before');
    }
  }
  else if( this.options.driver.match(/mysql|postgres/) )
    sequelizeOptions.host = this.options.host;

  // establish sequelizer connection
  this.sequelize = new Sequelize( this.options.database,
                                  this.options.username || null,
                                  this.options.password || null, sequelizeOptions);

  logger.info('db', 'connection to '+this.options.database+' established');
}

module.exports = ConnectionHandler;
