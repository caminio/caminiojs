/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _               = require('lodash');
var express         = require('express');
var i18next         = require('i18next');
var ejs             = require('ejs');

module.exports = function ServerSetup( caminio, app ){

  caminio.hooks.invoke('before', 'setup');

  app.use( express.cookieParser(caminio.config.session.secret) );
  
  app.use( express.json() );
  app.use( express.urlencoded() );

  app.use( i18next.handle );
  i18next.registerAppHelper( app );

  require('./session')( caminio, app );
  require('./flash')( caminio, app );

  // use jsonp callbacks
  app.set('jsonp callback', true);

  // default view engine to interpret html files
  app.engine( 'html', ejs.__express );

  // set up all viewEngines defined in
  // config/view_engines.js
  _.each( caminio.config.viewEngines, function( engineConfig, name ){
    caminio.logger.debug('registering view engine', name);
    _.each( engineConfig.ext, function( ext ){
      if( engineConfig.engine )
        app.engine( ext, engineConfig.engine );
      if( engineConfig.default && _.contains(engineConfig.ext, engineConfig.default) )
        app.set('view engine', engineConfig.default);
    });
  });

  //app.use( express.favicon() );
  
  if( caminio.env === 'production' )
    app.use( express.static( caminio.config.root+'/public' ) );
  else{
    caminio.views.publicPaths.forEach( function( publicPath ){
      console.log('setting up public path', publicPath);
      app.use( express.static( publicPath ) ); 
    });
  }
  
  //app.use( express.static( caminio.config.root+'/public' ) ); 

  // method override for 
  // delete/put methods
  app.use( express.methodOverride() );

  caminio.hooks.invoke('before', 'router');
  
  app.use( app.router );

  setupErrorPages();

    app.locals.pretty = true;
  if( caminio.env === 'development' ){
    app.use( express.errorHandler({ dumpExceptions: true, showStack: true }) );
    app.use(express.logger('dev'));
  }

  function setupErrorPages(){
    if( caminio.config.errors[404] )
      app.use( caminio.config.errors[404] );
  }
  
};