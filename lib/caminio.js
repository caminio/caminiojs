/* jshint node: true */
/* jshint expr: true */
'use strict';

var Logger          = require('./logger'),
    Server          = require('./server'),
    Initializer     = require('./initializer'),
    dbHandle        = require('./db_handle'),
    _               = require('lodash'),
    async           = require('async'),
    join            = require('path').join,
    asyncx          = require('../async_x'),
    mixin           = require('../util').mixin;

/**
 * @class Caminio
 * @constructor
 */
function Caminio( options, cb ){
  var app = this;
  options = typeof(options) === 'object' ? options : {};
  cb = typeof(cb) === 'function' ? cb : (typeof(options) === 'function' ? options : function(){});

  // assign defaults to this app instance
  app.config = _.merge({}, require('./config/defaults'), options);
  app.config.pkg = require('../package.json');
  
  app.env = app.config.env;
  app.root = process.cwd();
  app.version = app.config.pkg.version;
  
  // load from actual application directory
  app.config.appPkg = require( join( app.root, 'package.json' ) );
  app.appVersion = app.config.appPkg.version;
  _.merge( app.config, require( join( app.root, 'config', 'env.js' ) )[app.env] );
  
  app.logger = new Logger( app.config.log );

  // initialization process starts here
  async.series([
    asyncx.applyThis( app.initServer, app )
  ], cb);

}

mixin( Caminio.prototype, Server );
mixin( Caminio.prototype, Initializer );
mixin( Caminio.prototype, dbHandle );

module.exports = exports = Caminio;
