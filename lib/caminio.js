/* jshint node: true */
/* jshint expr: true */
'use strict';

var Logger          = require('./logger'),
    ServerMixin     = require('./mixins/server'),
    LoaderMixin     = require('./mixins/loader'),
    mixin           = require('../util').mixin;

/**
 * @class Caminio
 * @constructor
 */
function Caminio( options, cb ){
  options = typeof(options) === 'object' ? options : {};
  cb = typeof(cb) === 'function' ? cb : (typeof(options) === 'function' ? options : undefined);
  this.loadConfig( options );
  this.logger = new Logger( this.config.log );
  this.loadAppConfig();
  this.init( cb );
}

mixin( Caminio.prototype, ServerMixin );
mixin( Caminio.prototype, LoaderMixin );

module.exports = exports = Caminio;
