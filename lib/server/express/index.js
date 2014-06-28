/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var express         = require('express');

module.exports = function ServerExp( caminio ){

  var setup = require('./setup');
  caminio.globalExpressActions = require('./global_actions')(caminio);

  return {
    init: initExpress
  };

  function initExpress( cb ){

    var app = caminio.express = express();

    app.use(function(err, req, res, next) {
      if( err )
         caminio.logger.error('server error', err);
      next();
    });

    setup( caminio, app );

    if( cb ) cb();

  }

};
