/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */
var EventEmitter    = require('events').EventEmitter
  , async           = require('async');

module.exports = Caminio;

function Caminio(){

  'use strict';

  this.env = process.env.NODE_ENV = process.env.NODE_ENV || 'development';

  var gears     = require('../gears')(this);

  // the models collection
  this.models = {};

  this.controller = require('../controller')(this);

}

/**
 * Let Caminio emit events
 * @private
 */
Caminio.prototype = new EventEmitter();
Caminio.prototype.constructor = Caminio;

/**
 * initialize caminio
 *
 * @method init
 * @param {options} options [optional]
 */
Caminio.prototype.init = function initCaminio( options ){

  var self      = this
    , Server    = require('../server')(this);

  options = options || {};

  // check config settings in options object
  if( 'config' in options ){
    this.config = {};
    for( var i in options.config )
      this.config[i] = options.config[i];
  }

  var config    = require('../config')(this)
    , Logger    = require('../logger')(this);

  // a copy of the logger object
  this.logger = new Logger();

  var loader    = require('../loader')(this)

  // initialize but do not start the server
  this.server = new Server();

  async.auto({
    'collectModels': loader.collectModels,
    'collectMiddleware': loader.collectMiddleware,
    'collectPolicies': ['collectMiddleware', loader.collectPolicies ],
    'collectControllers': ['collectPolicies', loader.collectControllers ],
    'initialized': [ 'collectModels', 'collectControllers', function( cb ){ self.emit('initialized'); cb(); } ],
    'startServer': [ 'initialized', self.server.start ]
  });

  return this;

}