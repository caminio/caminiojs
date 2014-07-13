/* jshint node: true */
/* jshint expr: true */
'use strict';

var express         = require('express'),
    async           = require('async'),
    asyncx          = require('../async_x');

module.exports = exports = {

  /**
   * @class Caminio
   * @method init
   * @param {Function} callback
   *
   * initializes the express server engine
   * and reads app configuration
   */
  initServer: function( cb ){
    this.expressApp = express();
    cb();
  },

  /**
   * @class Caminio
   * @method start
   *
   * runs the server at config.port
   * defaults: 4000
   */
  run: function start( cb ){
    async.series([
      asyncx.applyThis( this.init, this ),
      asyncx.applyThis( startServer, this )
    ], typeof(cb) === 'function' && cb());
  },

};

function startServer( next ){
  /* jshint validthis: true */
  this.expressApp.listen( this.config.port );
  this.logger.info('caminio server', this.config.pkg.version, '['+this.env+' mode] running on port', this.config.port);
  next();
}

