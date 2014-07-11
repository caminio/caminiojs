/* jshint node: true */
/* jshint expr: true */
'use strict';

var express         = require('express');

module.exports = {

  /**
   * @class Caminio
   * @method init
   * @param {Function} callback
   *
   * initializes the express server engine
   * and reads app configuration
   */
  init: function( cb ){
    this.app = express();
    typeof(cb) === 'function' && cb();
  },

  /**
   * @class Caminio
   * @method start
   *
   * starts the server at given port or config.port
   * defaults: 4000
   */
  start: function start( port, cb ){
    this.app.listen( port || this.config.port || 4000 );
    this.logger.info('caminio server', this.config.pkg.version, 'running on port', port);
    typeof(cb) === 'function' && cb();
  }
};
