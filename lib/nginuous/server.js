var http = require('http');
var logger = require('./logger');

/**
 * get a new Server instance
 *
 * @param [app] {object} - the express js application
 * @param [options] {object} - optional parameters
 * * port - the port number to listen to when starting
 *
 */
function Server( app, options ){
  this.app = app;
  this.options = options;
}

/**
 * start the server
 *
 * @param [callback] {funcion} - an optional callback, called when ready
 *
 */
Server.prototype.start = function startServer( callback ){

  var self = this;

  http.createServer(self.app).listen( self.options.port, function(){
    logger.info('listening on port ' + self.options.port, 'server' );
    if( typeof( callback ) === 'function' )
      callback();
  });

}

module.exports = Server;
