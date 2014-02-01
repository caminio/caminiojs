/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */
var winston       = require('winston')
  , dirname       = require('path').dirname
  , fs            = require('fs')
  , mkdirp        = require('mkdirp')
  , util          = require('util');

module.exports = function Logger( caminio ){

  return Audit;

  /**
   * create a new audit logger instance
   * it will log to the settings entered in
   * config/audit.js
   *
   * if not enabled through config/audit.js,
   * it will just return a dummy function so
   * caminio.audit.log can still be used without
   * extra checking
   *
   * @class Audit
   * @constructor
   */
  function Audit(){

    if( !(caminio.config.audit && caminio.config.audit.enable) ){
      this.log = function(){};
      return;
    }

    /**
     * wrapper for the winston log method
     * determines the level and concatenates arguments
     * @api private
     */
    this.log = function(domainName) {
      var str = [];
      for(  var i in arguments ){
        if( i === '0' ) continue;
        var arg = arguments[i];
        if (typeof arg === 'object') {
          if (arg instanceof Error) {
            str.push(arg.stack);
            return;
          }

          str.push(util.inspect(arg));
          return;
        }

        if (typeof arg === 'function') {
          str.push(arg.valueOf());
          return;
        }

        str.push(arg);
      }

      var logger = this.logger = new winston.Logger();

      if( !fs.existsSync(caminio.config.audit.path) )
        mkdirp(caminio.config.audit.path);

      logger.add(
        winston.transports.File, { 
          level: 'info', 
          colorize: false,
          filename: caminio.config.audit.path+'/'+domainName+'.log'
        });

      logger.log('info', str.join(' '));

    };
    
  }

};