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
   * runs the server at config.port
   * defaults: 4000
   */
  run: function start( cb ){
    this.app.listen( this.config.port );
    this.logger.info('caminio server', this.config.pkg.version, 'running on port', this.config.port);
    typeof(cb) === 'function' && cb();
  }
};
