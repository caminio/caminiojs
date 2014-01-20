/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var express         = require('express')
  , i18next         = require('i18next')
  , flash           = require('connect-flash');

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

  app.set('view engine', 'ejs');

  app.use( express.favicon() );
  caminio.views.assetPaths.forEach( function( assetPath ){
    app.use( express.static( assetPath ) ); 
  });

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