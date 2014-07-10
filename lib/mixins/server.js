/* jslint node: true */
'use strict';

var koa         = require('koa');

var server = module.exports;

server.initServer = function(){
  this.app = koa();
};

server.listen = function( port ){
  this.app.listen( port );
  this.logger.info('caminio server', this.config.pkg.version, 'running on port', port);
};
