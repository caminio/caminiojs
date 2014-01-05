/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , fs = require('fs')
  , express = require('express')
  , MongoStore = require('connect-mongo')(express)
  , flash = require('connect-flash')
  , i18n = require('i18next')
  , i18nFactory = require('./i18n_factory')
  , http = require('http')
  , io = require('socket.io')
  , logger = require('./logger')
  , router = require('./router')
  , passportStrategies = require('./passport_strategies')
  , passport = require('passport');

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

  self.server = http.createServer(self.app.express).listen( self.app.config.port, function(){
    logger.info('server', 'listening on port ' + self.app.config.port );
    self.running = true;
    self.started = new Date();
    if( typeof( callback ) === 'function' )
      callback( self.app );
  });

  self.io = io.listen(self.server);

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
Server.prototype.webSetup = function webSetup( callback ){
 
  this.app.express = express();
  var db = this.app.db;

  this.i18n = i18n.init({
    resStore: i18nFactory.getTranslations(this.app),
    fallbackLng: 'en',
    ns: 'nginios',
    useCookie: false,
    detectLngFromHeaders: false
  });

  this.app.express.use(express.cookieParser('nginios sec'));
  //this.app.express.use(express.bodyParser());
  this.app.express.use(express.json());
  this.app.express.use(express.urlencoded());

  this.app.express.use(i18n.handle);
  i18n.registerAppHelper(this.app.express);

  this.app.express.use(express.session({
    secret: this.app.config.session_secret,
    store: new MongoStore({
      db: db.options.name,
      collection: 'sessions'
    })
  }));

  this.app.express.use(flash())
  this.app.express.locals.resolvePath = router.resolve;
  this.app.express.locals.nginios = {};
  this.app.express.locals.nginios.version = JSON.parse( fs.readFileSync(__dirname+'/../../package.json') ).version;
  this.app.express.locals.nginios.env = this.app.environment;
  this.app.express.locals.nginios.config = this.app.config;
  this.app.express.locals.getHbsFileContent = function( filename ){ return fs.readFileSync( filename ); };

  this.app.express.use(passport.initialize());
  this.app.express.use(passport.session());

  // security
  if( this.app.environment !== 'test' )
    this.app.express.use(express.csrf());

  // passport security (auth)
  passportStrategies();
  this.app.express.use(passport.initialize());

  this.app.express.use(express.static(path.join(__dirname, '..', '..', 'public')));
  for( var i in this.app.gears )
    if( this.app.gears[i].staticPath )
      this.app.express.use(express.static(this.app.gears[i].staticPath));

  this.app.express.set('views', path.join( __dirname+'/../../', 'views'));
  this.app.express.set('view engine', 'jade');
  this.app.express.engine('html', require('ejs').renderFile);
  this.app.express.use(express.favicon());
  this.app.express.use(express.logger('dev'));
  this.app.express.use(express.methodOverride());
  this.app.express.use(this.app.express.router);



  // development only
  if( this.app.environment === 'development' || this.app.environment === 'test' ){
    this.app.express.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    this.app.express.locals.pretty = true;
  }

  if( this.app.environment === 'test' )
    require(process.cwd()+'/test/support/routes');
  else
    require(process.cwd()+'/config/routes');

  if( typeof(callback) === 'function' )
    callback( this.app.express );

}

module.exports = Server;
