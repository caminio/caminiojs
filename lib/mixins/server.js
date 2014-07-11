/* jslint node: true */
'use strict';

var express         = require('express');

var server = module.exports;

server.initServer = function(){
  this.app = express();
};

server.listen = function( port ){
  this.app.listen( port );
  this.logger.info('caminio server', this.config.pkg.version, 'running on port', port);
};
