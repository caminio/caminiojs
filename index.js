/* jshint node: true */
/* jshint expr: true */
'use strict';

var Logger          = require('./lib/logger'),
    ServerMixin     = require('./lib/mixins/server'),
    LoaderMixin     = require('./lib/mixins/loader'),
    mixin           = require('./util').mixin;

/**
 * @class Caminio
 * @constructor
 */
function Caminio( options, cb ){
  options = arguments.length > 2 && typeof(options) === 'object' ? options : {};
  cb = cb && typeof(cb) === 'function' ? cb : (options && typeof(options) === 'function' ? options : undefined);
  this.loadConfig( options );
  this.logger = new Logger( this.config.log );
  this.loadAppConfig();
  this.init( cb );
}

mixin( Caminio.prototype, ServerMixin );
mixin( Caminio.prototype, LoaderMixin );

/**
 * @method caminio
 * @return {Caminio} caminio instance
 */
module.exports = exports = function(){
  
  return new Caminio();

};
