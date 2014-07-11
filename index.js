/* jslint node: true */
'use strict';

var _               = require('lodash');

var Logger          = require('./lib/logger');
var ServerMixin     = require('./lib/mixins/server');
var mixin           = require('./util').mixin;

/**
 * @class Caminio
 * @constructor
 */
function Caminio( options, cb ){
  options = arguments.length > 2 && typeof(options) === 'object' ? options : {};
  cb = cb && typeof(cb) === 'function' ? cb : (options && typeof(options) === 'function' ? options : undefined);
  this.config = _.merge({}, require('./lib/config/defaults'), options);
  this.config.pkg = require('./package.json');
  this.env = this.config.env;
  this.logger = new Logger( this.config.log );
  this.init( cb );
}

mixin( Caminio.prototype, ServerMixin );

/**
 * @method caminio
 * @return {Caminio} caminio instance
 */
module.exports = function(){
  
  return new Caminio();

};
