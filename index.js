/* jslint node: true */
'use strict';

var _               = require('lodash'),
    Promise         = require('bluebird');

var Logger          = require('./lib/logger');
var ServerMixin     = require('./lib/mixins/server');
var mixin           = require('./util').mixin;

/**
 * @class Caminio
 * @constructor
 */
function Caminio( options ){
  this.config = _.merge({}, require('./lib/config/defaults'), options);
  this.config.pkg = require('./package.json');
  this.env = this.config.env;
  this.status = 'initialized';
  this.logger = new Logger( this.config.log );
}

mixin( Caminio.prototype, ServerMixin );

Caminio.prototype.init = function init( cb ){
  this.initServer();
};

/**
 * @class Caminio
 * @method start
 *
 * starts the server at given port or config.port
 * defaults: 4000
 */
Caminio.prototype.start = function start(){
  this.listen( this.config.port || 4000 );
  this.status = 'running';
  return this;
};

module.exports = Caminio;
