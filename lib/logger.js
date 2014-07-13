/* jslint node: true */
'use strict';

require('colors');

var _           = require('lodash'),
    dirname     = require('path').dirname,
    mkdirp      = require('mkdirp'),
    fs          = require('fs');

module.exports = Logger;

var logLevels = {
  'verbose':  5,
  'debug':    4,
  'info':     3,
  'warn':     2,
  'error':    1,
  'silent':   0
};

/**
 * @class Logger
 * @constructor
 * @param {Object} options
 * @param {Object} options.level the log level to use
 * @param {Object} options.to the destination to log to (currently only supports absolute file path or 'console'
 *
 * available log levels are:
 * * verbose
 * * debug
 * * info
 * * warn
 * * error
 * * silent
 *
 */
function Logger( options ){
  this.config = _.merge({ level: 'debug', to: 'console' }, options);
}

/**
 * @class Logger
 * @method log
 * @private
 */
Logger.prototype.log = function log( level ){
  if( logLevels[level] < this.config.level )
    return;
  var message = Array.prototype.slice.call(arguments);
  message.splice(0,1);
  if( this.config.to === 'console' )
    return console.log( colorify(level, message.join(' ')) );
  if( !fs.existsSync( dirname( this.config.to ) ) )
    mkdirp.sync( dirname(this.config.to) );
  fs.appendFileSync( this.config.to, Array.prototype.concat([ level ], message).join(' ') );
};

/**
 * @class Logger
 * @method debug
 */
Logger.prototype.debug = function info(){
  this.log.apply( this, Array.prototype.concat(['debug'], Array.prototype.slice.call(arguments) ) );
};

/**
 * @class Logger
 * @method info
 */
Logger.prototype.info = function info(){
  this.log.apply( this, Array.prototype.concat(['info'], Array.prototype.slice.call(arguments) ) );
};

/**
 * @class Logger
 * @method warn
 */
Logger.prototype.warn = function warn(){
  this.log.apply( this, Array.prototype.concat(['warn'], Array.prototype.slice.call(arguments) ) );
};

/**
 * @class Logger
 * @method error
 */
Logger.prototype.error = function error(){
  this.log.apply( this, Array.prototype.concat(['error'], Array.prototype.slice.call(arguments) ) );
};

function colorify( level, message ){
  message = level + ': ' + message;
  if( logLevels[level] === 2 )
    return message.yellow;
  if( logLevels[level] === 1 )
    return message.red;
  if( logLevels[level] === 3 )
    return message.blue;
  else
    return message;
}

