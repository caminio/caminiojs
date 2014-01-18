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

  return {
    init: initExpress
  }

  function initExpress( cb ){

    var app = caminio.express = express();
    setup( caminio, app );

    if( cb ) cb();

  }

}  