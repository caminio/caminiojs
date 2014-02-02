/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */
var EventEmitter    = require('events').EventEmitter;
var async           = require('async');
var basename        = require('path').basename;
var dirname         = require('path').dirname;

var util            = require('../util');
var Gear            = require('../gear');

module.exports = Caminio;

function Caminio(){

  'use strict';

  this.env = process.env.NODE_ENV = process.env.NODE_ENV || 'development';

  //var gears     = require('../gears')(this);
  this.gears = require('../gear').registry;
  this.i18n  = require('../i18n')(this);

  // global helper functions
  this.helpers = {};

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

  var self      = this;
  var Server    = require('../server')(this);

  options = options || {};

  // check config settings in options object
  if( 'config' in options ){
    this.config = {};
    for( var i in options.config )
      this.config[i] = options.config[i];
  }

  var config    = require('../config')(this);
  var Logger    = require('../logger')(this);
  var Audit     = require('../audit')(this);
  var db        = require('../db')(this);
  self.mailer   = require('../mailer')(this);

  // a copy of the logger object
  this.logger = new Logger();
  this.audit  = new Audit();

  var loader    = require('../loader')(this);

  async.auto({
    'collectHooks': loader.collectHooks,
    'collectConfig': [ 'collectHooks', loader.collectConfig ],
    'initServer': ['collectConfig', function( cb ){ self.server = new Server(); cb(); } ],
    'connectDatabase': ['collectConfig', db.connect ],
    'collectModels': ['collectConfig', loader.collectModels ],
    'collectMiddleware': ['collectConfig', 'connectDatabase', loader.collectMiddleware ],
    'collectPolicies': ['collectMiddleware', loader.collectPolicies ],
    'collectControllers': ['collectPolicies', loader.collectControllers ],
    'collectViews': ['collectConfig', loader.collectViews ],
    'initialized': [ 'collectModels', 'collectControllers', function( cb ){ self.emit('initialized'); cb(); } ],
    'startServer': [ 'initialized', function( cb ){ self.server.start( cb ); } ]
  });

  return this;

};

/**
 * run a caminio application and setup 
 * the app as an api
 *
 * invokes init
 *
 * @method run
 */
Caminio.prototype.run = function runCaminio( modules ){

  var caller = util.getCaller();
  this.mainGear = new Gear({ api: true, absolutePath: dirname(caller.filename), name: basename(dirname( caller.filename )) });

  this.init();

};