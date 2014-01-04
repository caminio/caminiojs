/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , fs = require('fs')
  , logger = require('./logger')
  , router = require('./router')
  , gearFactory = require('./gear_factory')
  , views = require('./views');

/**
 * PRIVATE METHODS
 *
 */
function getValidRoutePath( prefix, route ){
  var pth = prefix + route;
  if( pth.lastIndexOf('/') === pth.length-1 )
    pth = pth.substr(0,pth.length-1);
  return pth;
}

/**
 * Controller
 *
 * a route controller
 *
 * @example:
 *
 *    new Controller( function(){
 *      this.get('/', function( req, es ){});
 */
var Controller = function(){
  this.routes = { get: {}, put: {}, delete: {}, post: {} };
  this.hooks = { before: [] };
};

Controller.define = function( definitionsCallback ){
  return function( prefix, gear, name, app ){
    var controller = new Controller();
    for( var i in controller )
      this[i] = controller[i];
    this.name = name;
    this.prefix = prefix;
    this.app = app;
    this.gear = gear;
    this.preprocessors();
    definitionsCallback.call( this, app, prefix );
    this.initRoutes( prefix, app );
  }
}

/**
 * preprocessors for routes
 *
 * @class Controller
 * @method preprocessors
 **/
Controller.prototype.preprocessors = function preprocessors(){
    this.infiltrateResWithnginios();
    this.addLocals();
}

/**
 * add locals to res.locals
 **/
Controller.prototype.addLocals = function addLocals(){
  var self = this;
  this.before( 
      function( req, res, next ){
        res.locals.messages = {
          info: req.flash('info'),
          error: req.flash('error')
        };
        //res.header("Access-Control-Allow-Origin", "*");
        res.locals.messages.count = 0;
        res.locals.messages.count += res.locals.messages.info.length;
        res.locals.messages.count += res.locals.messages.error.length;
        res.locals.csrf =  ( self.app.environment !== 'test' ? req.session.req.csrfToken() : '' );
        res.locals.currentUser = req.user;
        res.locals.currentDomain = req.session.domain || ( req.user && req.user.domains && req.user.domains[0] );
        res.locals.getApplicationsForUser = function(){ return gearFactory.getApplicationsForUser( self.app.gears, res.locals.currentUser, res.locals.currentDomain, req.i18n ); };
        res.locals.handlebarTemplates = self.gear.hbs;
        next();
      });
}

/**
 * resolve given path (call router)
 **/
Controller.prototype.resolvePath = function resolvePath( controller, action, silent ){
  controller = controller || this.name;
  return router.resolve( controller, action, silent );
}

/**
 * infiltratres res object
 * with nginnios object and render method
 *
 * @class Controller
 * @method infiltratreResWithnginios
**/
Controller.prototype.infiltrateResWithnginios = function infiltrateResWithnginios(){
  var self = this;
  this.before( 
      function( req, res, next ){
        logger.info('router', self.prefix+' served by controller: '+self.name);
        res.nginios = {};
        // render by looking up the view paths
        // in all registered view directories
        res.nginios.render = function renderView( filename, options ){
          options = options || {};
          // this won't work, until we have implemented our own jade.compile function here
          //options.layout = self.layout || path.normalize(path.join(__dirname,'..','..','app','views','v1','layout.jade'));
          var absPath = views.get( path.join(self.name,filename) );
          if( !absPath )
            absPath = views.get( filename );
          res.render( absPath, options );
        }
        next();
      });
}

/**
 * initializes express routes
 *
 * @api private
 */
Controller.prototype.initRoutes = function initRoutes( prefix, app ){
  for( var routeType in this.routes ){
    for( var route in this.routes[routeType] ){
      var args = [ getValidRoutePath(prefix,route) ];
      args = args.concat( this.getBeforeHooks( route ) );
      var hsh = this.routes[routeType][route];
      for( var i in hsh )
        if( parseInt(i) > 0 )
          args.push( hsh[i] );
      try{
        app.express[routeType].apply( app.express, args );
      } catch(e){
        logger.error('gear', 'faulty route: ' + require('util').inspect(args).toString() );
        throw e;
      }
    }
  }
}

/**
 * get before hooks
 *
 * @param {String} - route name
 * @return {Array} - the collected functions for the hook
 *
 * @api private
 */
Controller.prototype.getBeforeHooks = function getBeforeHooks( routeName ){
  var hooks = [];
  this.hooks.before.forEach( function(hook){
    if(!( hook.exceptions && hook.exceptions.indexOf(routeName) >= 0 ) )
      hooks.push( hook.fn );
  });
  return hooks;
}

/**
 * a get route
 */
Controller.prototype.get = function get( name ){
  this.routes.get[name] = arguments;
}

/**
 * a post route
 */
Controller.prototype.post = function post( name ){
  this.routes.post[name] = arguments;
}

/**
 * a put route
 */
Controller.prototype.put = function put( name ){
  this.routes.put[name] = arguments;
}

/**
 * a delete route
 */
Controller.prototype.delete = function deletePath( name ){
  this.routes.delete[name] = arguments;
}

/**
 * before hook
 */
Controller.prototype.before = function before(){
  var self = this;
  var exceptions = [];
  for( var i in arguments ){
    var arg = arguments[i];
    if( typeof(arg) === 'object' && 'except' in arg ){
      if( typeof(arg.except) === 'array' )
        arg.except.forEach( function(exc){
          exceptions.push( exc );
        });
      else
        exceptions.push( arg.except )
    }
  }
  var foundFn;
  for( var i in arguments )
    if( typeof(arguments[i]) === 'function' ){
      foundFn = true;
      this.hooks.before.push({
        exceptions: exceptions,
        fn: arguments[i]
      });
    }

  if( !foundFn )
    throw Error( '[nginios] ' + this.name + ': call of before hook without passing a function. This might not be what you are after (?)' )

}


module.exports = Controller;
