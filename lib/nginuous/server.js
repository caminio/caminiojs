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
  this.running = false;
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
    logger.info('server', 'listening on port ' + self.options.port );
    self.running = true;
    self.started = new Date();
    if( typeof( callback ) === 'function' )
      callback();
  });

}

/**
 * return the server status
 *
 * @return {boolean} - if the server is running or not
 */
Server.prototype.status = function serverStatus(){
  return {
    running: this.running,
    up: (( this.started instanceof Date ) ? (new Date() - this.started) : null)
  }
}

module.exports = Server;
