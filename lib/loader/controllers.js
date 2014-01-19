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

  var ctrlStack
    , policiesStack
    , middlewareStack
    , loadedControllers = {};

  return {
    init: init
  };

  function init( stack, middleware, policies, cb ){
  
    ctrlStack = stack;
    middlewareStack = middleware;
    policiesStack = policies;

    _.each( caminio.config.routes, function( controllerStr, route ){

      var controllerName    = controllerStr.split('#')[0]
        , controllerAction  = null;

      if( route === 'auto' )
        return createAutoAll( route, controllerName );

      if( _.contains( route, 'resource' ) )
        return createResource( route, controllerName );

      if( controllerStr.split('#').length > 1 )
        controllerAction = controllerStr.split('#')[1];

      if( _.contains( route, 'post') )
        return crateRoute( 'post', route, controllerName, controllerAction );

      if( _.contains( route, 'put') )
        return crateRoute( 'put', route, controllerName, controllerAction );

      if( _.contains( route, 'delete') )
        return crateRoute( 'delete', route, controllerName, controllerAction );

      // 'get' or no http type 
        return createRoute( 'get', route, controllerName, controllerAction );

    });

    cb();

  }


  /**
   * creates an express compatible route
   *
   * @param {String} type http type
   * @param {String} route the route including the type
   * @param {String} controllerName
   * @param {String} controllerAction
   */
  function createRoute( type, route, controllerName, controllerAction ){

    route = cleanRoute( route, type );

    if( controllerName in ctrlStack ){

      var controller = loadedControllers[controllerName] =
        loadedControllers[controllerName] || ctrlStack[controllerName]( caminio, policiesStack, middlewareStack );

      if( !(controllerAction in controller) )
        return caminio.logger.warn('controller', controllerName, 'has no action', controllerAction);

      caminio.controller.registerRoute( type, route, controllerName, controllerAction );

      var actions = [ route ];
      actions.push( setControllerAndActionNames(type, route, controllerName, controllerAction) );
      actions = setGlobalBeforeActions( actions );
      actions = setControllerBeforeActions( actions, controller, controllerAction );
      actions = actions.concat( controller[controllerAction] );
      caminio.express[type].apply( caminio.express, actions );

    } else 
      caminio.logger.warn('controller', controllerName, 'is unknown (used in route:', route, ')');

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
    createRoute( 'get', route, controllerName, 'index' );
    createRoute( 'get', route+'/:id', controllerName, 'show' );
    createRoute( 'post', route, controllerName, 'create' );
    createRoute( 'put', route+'/:id', controllerName, 'update' );
    createRoute( 'delete', route+'/:id', controllerName, 'destroy' );
  }


  function cleanRoute( route, type ){
    var regexp = new RegExp( type + '[ ]*' );
    return route.replace( regexp, '' );
  }

  /**
   * @method setControllerBeforeActions
   * @param {Array} actions
   * @param {Object} controller
   * @param {String} controllerAction
   * @return {Array} actions
   * @private
   */
  function setControllerBeforeActions( actions, controller, controllerAction ){
    if( !('_before' in controller) ) return actions;
    _.each( controller._before, function( actionFn, controllers ){
      if( controllers === '*' || _.contains( controllers.split(','), controllerAction) )
        if( actionFn instanceof Array )
          actionFn.forEach(function(action){ actions.push(action); });
        else
          actions.push( actionFn );
    });
    return actions;
  }

  /**
   * @method setGlobalBeforeActions
   * @param {Array} actions
   * @return {Array} globalActions to be applied
   * @private
   */
  function setGlobalBeforeActions( actions ){
    return actions.concat( caminio.globalExpressActions );
  }

  function setControllerAndActionNames( type, route, controllerName, actionName ){
    return function( req, res, next ){
      req.controllerName = controllerName;
      req.actionName = actionName;
      req.routeName = route;
      next();
    }
  }

}