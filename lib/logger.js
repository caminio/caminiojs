/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */
var winston       = require('winston'),
  dirname       = require('path').dirname,
  fs            = require('fs'),
  mkdirp        = require('mkdirp'),
  util          = require('util');

module.exports = function( caminio ){

  return Logger;

  /**
   * create a new logger instance
   */
  function Logger(options){

    options = options || {};
    options.loglevel = options.loglevel || 'debug';

    var config = {};
    config.colorize = config.colorize || true;

    this.levels = {
      silent: 4,
      error: 3,
      warn: 2,
      info: 1,
      debug: 0
    };

    config.level = this.levels[options.loglevel];

    var logger = this.logger = new winston.Logger();

    this.warn = log('warn');
    this.error = log('error');
    this.debug = log('debug');
    this.info = log('info');


    if( caminio.env === 'development' )
      this.logger.add(
        winston.transports.Console, { 
          level: options.loglevel || 'debug', 
          colorize: true
        });
    else{
      if( !fs.existsSync(dirname(caminio.config.log.filename)) )
        mkdirp(dirname(caminio.config.log.filename));
      this.logger.add(
        winston.transports.File, { 
          level: options.loglevel || 'info', 
          colorize: false,
          filename: caminio.config.log.filename,
          handleExceptions: true
        });
    }

    var self = this;
    this.info('caminio logger started with level', options.loglevel);

    /**
     * wrapper for the winston log method
     * determines the level and concatenates arguments
     * @api private
     */
    function log( level ){
      return function() {
        var str = [];
        for( var i in arguments ){
          var arg = arguments[i];
          if (typeof arg === 'object' && arg instanceof Error) {
            if (arg instanceof Error)
              str.push(arg.stack);
            else
              str.push(util.inspect(arg));
          } else if( typeof(arg) === 'function' )
            str.push(arg.valueOf());
          else
            str.push(arg);
        }
        if ( self.levels[level] >= config.level ) {
          var args = Array.prototype.slice.call(arguments);
          args.unshift(level);
          self.logger.log.apply(self.logger,args);

          if( caminio.config.loggers || caminio.config.loggers instanceof Array )
            caminio.config.loggers.forEach(function(addLogger){
              addLogger.log(str.map(function(s){ return s ? s.toString() : ''; }).join(','));
            });
        }
      };
    }
    
  }

};
