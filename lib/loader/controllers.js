/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash')
  , inflection    = require('inflection')
  , async         = require('async');

module.exports = function( caminio ){

  var autorest      = require('../controller/autorest')(caminio);

  return {
    init: init
  };

  function init( stack, middleware, policies, cb ){
  
    _.merge(caminio.controller.stack, stack);
    _.merge(caminio.controller.middleware, middleware);
    _.merge(caminio.controller.policies, policies);

    createRoutes();

    cb();

  }

  /**
   * reads defined routes from all collected
   * routes.js, parses them and loads referenced
   * controllers in routes.
   *
   * If a controller is not referenced in any route,
   * it will not be loaded.
   *
   * @method createRoutes
   * @private
   */
  function createRoutes(){

    _.each( caminio.config.routes, function( controllerStr, route ){

      var controllerName    = controllerStr.split('#')[0]
        , controllerAction  = null;

      if( _.contains( route.toLowerCase(), 'resource' ) )
        return createResource( route, controllerName );

      if( _.contains( route.toLowerCase(), 'autorest' ) ){
        controllerName = _.contains( controllerName, 'Controller' ) ? controllerName : controllerName+'Controller';
        autorest.create( controllerName, cleanRoute( route, 'autorest' ) );
      }

      if( controllerStr.split('#').length > 1 )
        controllerAction = controllerStr.split('#')[1];

      if( _.contains( route.toLowerCase(), 'post') )
        return caminio.controller.createRoute( 'post', cleanRoute( route, 'post' ), controllerName, controllerAction );

      if( _.contains( route.toLowerCase(), 'put') )
        return caminio.controller.createRoute( 'put', cleanRoute( route, 'put' ), controllerName, controllerAction );

      if( _.contains( route.toLowerCase(), 'delete') )
        return caminio.controller.createRoute( 'delete', cleanRoute( route, 'delete' ), controllerName, controllerAction );

      // 'get' or no http type 
        return caminio.controller.createRoute( 'get', cleanRoute( route, 'get' ), controllerName, controllerAction );

    });

  }

  /**
   * reads in controller's CRUD methods an auto-connects
   * them to express
   *
   * @param {String} route
   * @param {String} controllerName
   *
   *
   * following route names will be mapped:
   *
   *     'index'      =>   'GET <controllerName>/' 
   *     'show'       =>   'GET <controllerName>/:id' 
   *     'create'     =>   'POST <controllerName>/' 
   *     'update'     =>   'PUT <controllerName>/:id' 
   *     'destroy'    =>   'DELETE <controllerName>/:id'
   *
   */
  function createResource( route, controllerName ){
    route = cleanRoute( route, 'resource' );
    caminio.controller.createRoute( 'get', route, controllerName, 'index' );
    caminio.controller.createRoute( 'get', route+'/:id', controllerName, 'show' );
    caminio.controller.createRoute( 'post', route, controllerName, 'create' );
    caminio.controller.createRoute( 'put', route+'/:id', controllerName, 'update' );
    caminio.controller.createRoute( 'delete', route+'/:id', controllerName, 'destroy' );
  }


  function cleanRoute( route, type ){
    var regexp = new RegExp( type + '[ ]*', 'i' );
    return route.replace( regexp, '' );
  }

}