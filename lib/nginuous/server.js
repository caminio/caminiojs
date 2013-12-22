var path = require('path')
  , express = require('express')
  , http = require('http')
  , logger = require('./logger')
  , passport = require('passport')
  , OAuth2Strategy = require('passport-oauth').OAuth2Strategy;

/**

get a new Server instance. This server is instantiated
when instantiating the Application and available to the
app.server object pointer

@class Server
@param [app] {object} - an Application instance

@private

 **/
function Server( app ){
  this.app = app;
  this.running = false;
}

/**
start the server

@method start
@param {Function} callback a callback function to be executed after server has started successfully

**/
Server.prototype.start = function startServer(callback){

  var self = this;

  http.createServer(self.app.express).listen( self.app.config.port, function(){
    logger.info('server', 'listening on port ' + self.app.config.port );
    self.running = true;
    self.started = new Date();
    if( typeof( callback ) === 'function' )
      callback( self.app );
  });

}

/**

@method status
@return {boolean} - if the server is running or not

**/
Server.prototype.status = function serverStatus(){
  return {
    running: this.running,
    up: (( this.started instanceof Date ) ? (new Date() - this.started) : null)
  }
}

/**
default setup actions for expressjs

@method webSetup
@private
@param {Function} callback an optional callback executed after this function is finished

**/
Server.prototype.webSetup = function webSetup(){
 
  this.app.express = express();
  this.app.express.set('views', path.join(__dirname, 'views'));
  this.app.express.set('view engine', 'ejs');
  this.app.express.use(express.favicon());
  this.app.express.use(express.logger('dev'));
  this.app.express.use(express.json());
  this.app.express.use(express.urlencoded());
  this.app.express.use(express.methodOverride());
  this.app.express.use(this.app.express.router);
  this.app.express.use(express.static(path.join(__dirname, 'public')));
  this.app.express.use(passport.initialize());
  this.setupOAuth();

  // development only
  if( this.app.environment === 'development' ){
    this.app.express.use(express.errorHandler());
  }

  if( this.app.environment === 'test' )
    require(process.cwd()+'/test/support/routes');
  else
    require(process.cwd()+'/config/routes');

}

Server.prototype.setupOAuth = function setupOAuth(){
  passport.use('provider', new OAuth2Strategy({
      authorizationURL: '/oauth2/authorize',
      tokenURL: '/oauth2/token',
      clientID: '123-456-789',
      clientSecret: 'shhh-its-a-secret',
      callbackURL: 'https://www.example.com/auth/provider/callback'
    }, this.app.gears.nginuous.auth.try ));
}

module.exports = Server;
