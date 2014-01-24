/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _               = require('lodash')
  , express         = require('express')
  , i18next         = require('i18next')
  , ejs             = require('ejs');

module.exports = function ServerSetup( caminio, app ){

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
      app.engine( ext, engineConfig.engine );
      if( engineConfig.default && _.contains(engineConfig.ext, engineConfig.default) )
        app.set('view engine', engineConfig.default);
    });
  });

  app.use( express.favicon() );
  /*
  caminio.views.assetPaths.forEach( function( assetPath ){
    console.log('setting up assets path', assetPath);
    app.use( express.static( assetPath ) ); 
  });
  */
  app.use( express.static( caminio.config.root+'/public' ) ); 

  // method override for 
  // delete/put methods
  app.use( express.methodOverride() );

  app.use( app.router );

  setupErrorPages();

  if( caminio.env === 'development' ){
    app.use( express.errorHandler({ dumpExceptions: true, showStack: true }) );
    app.use(express.logger('dev'));
  }

  function setupErrorPages(){
    if( caminio.config.errors[404] )
      app.use( caminio.config.errors[404] );
  }
  
}