/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _           = require('lodash');
var join        = require('path').join;
var extname     = require('path').extname;
var util        = require('util');
var inflection  = require('inflection');

module.exports = function GlobalExpressActions( caminio ){

  return [
    logControllerAction,
    injectCaminioRender
  ];

  function logControllerAction( req, res, next ){
    caminio.logger.info( 'serving ', req.method, req.routeName, ' with ', req.controllerName+'#'+req.actionName );
    if( Object.keys(req.params).length > 0 )
      caminio.logger.debug( 'params\n', util.inspect(req.params) );
    if( Object.keys(req.body).length > 0 )
      caminio.logger.debug( 'body:\n', util.inspect(req.body) );
    if( Object.keys(req.query).length > 0 )
      caminio.logger.debug( 'query:\n', util.inspect(req.query) );
    next();
  }

  function injectCaminioRender( req, res, next ){
    res.caminio = {};
    // render by looking up the view paths
    // in all registered view directories
    res.caminio.render = function renderView( filename, options ){

      if( typeof(filename) === 'object' ){
        options = filename;
        filename = null;
      }
      options = options || {};

      //_.merge( options, res.locals );
      var controllerName = inflection.underscore(req.controllerName).replace('_controller','');

      // layout
      options.layout = options.layout ? caminio.views.lookup( options.layout ) : caminio.views.lookup( join( controllerName, 'layout' ) );
      if( !options.layout ){ options.layout = caminio.views.lookup( 'layouts/application' ); }
      
      // resolve path
      filename = filename || join( controllerName, req.actionName );
      var absPath = caminio.views.lookup( filename );
      
      if( !absPath )
        absPath = caminio.views.lookup( join( controllerName, filename ) );
      if( !absPath ){
        caminio.logger.error('failed to lookup view', filename);
        absPath = caminio.views.lookup( '404' );
      }
      
      var ext = extname( absPath ).replace('.','');
      var execEngine;
      for( var i in caminio.config.viewEngines )
        if( _.contains(caminio.config.viewEngines[i].ext,ext) )
          execEngine = caminio.config.viewEngines[i].exec

      if( typeof(execEngine) === 'function' )
        execEngine( caminio, req, res, function(){
          // TODO: find solution to set layouts dynamically.
          // currently this is a limitation by template render engines
          // res.locals.layout = caminio.views.lookup( options.layout || 'layouts/application' );
          res.render( absPath, options );
        });
      else
        res.render( absPath, options );
    }
    next();
  }

}
