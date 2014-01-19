/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var http      = require('http');

module.exports = function ServerExp( caminio ){;

  var express = require('./express')(caminio);
  caminio.views = require('./views')(caminio);

  function Server( cb ){
    express.init( cb );
  }

  Server.prototype.start = function startServer(){

    caminio.i18n.init();

    http.createServer(caminio.express).listen( caminio.config.port, function(){
      caminio.logger.info('caminio server version', caminio.config.version, 'running on port', caminio.config.port);
      caminio.emit('ready');
    });
  }

  return Server;

}