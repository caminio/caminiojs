/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

'use strict';

var _             = require('lodash');
var util          = require('util');
var join          = require('path').join;
var fs            = require('fs');

module.exports = function( caminio ){

  var registeredRoutes = [];
  var loaded = {};
  var stack = {};
  var policies = {};
  var middleware = {};

  return {
    stack: stack,
    policies: policies,
    middleware: middleware,
    routes: routes,
    registerRoute: registerRoute,
    createRoute: createRoute,
    load: loadController
  };


  /**
   * registers a new route to 
   * caminio. This is mainly used, to control
   * wether a route is set up and for feedback purposes for the developer
   *
   * @method registerRoute
   * @param {String} verb
   * @param {String} path
   * @param {String} controllerName
   * @param {String} controllerAction
   */
  function registerRoute( verb, path, controllerName, controllerAction ){

    registeredRoutes.push({ 
      path: path, 
      verb: verb, 
      controllerName: controllerName, 
      controllerAction: controllerAction 
    });

  }


  /**
   * creates an express compatible route
   *
   * @param {String} type http type
   * @param {String} route the type cleared route
   * @param {String} controllerName
   * @param {String} controllerAction
   */
  function createRoute( type, route, controllerName, controllerAction ){

    if( controllerName in stack ){

      // caminio.logger.debug('route', type, route, controllerName, controllerAction );
      var controller = loadController(controllerName);

      if( !(controllerAction in controller) )
        return caminio.logger.warn('controller', controllerName, 'has no action', controllerAction);

      registerRoute( type, route, controllerName, controllerAction );

      var actions = [ route ];
      actions = setControllerAuthPolicies( actions, controller, controllerAction );
      actions.push( setControllerAndActionNames(type, route, controllerName, controllerAction) );
      actions = setGlobalBeforeActions( actions );
      actions = setControllerBeforeActions( actions, controller, controllerAction );
      actions = actions.concat( controller[controllerAction] );
      actions = setInterceptResponseActions( actions, controller, controllerAction );
      if( testValid(actions) )
        caminio.express[type.toLowerCase()].apply( caminio.express, actions );

    } else 
      caminio.logger.warn('controller', controllerName, 'is unknown (used in route:', route, ')');

  }

  /**
   * @method routes
   * @return {String} routes
   */
  function routes(){
    return registeredRoutes.map( function(route){
      return route.path + ' ' + route.verb.toUpperCase() + ' ' + route.controllerName + '#' + route.controllerAction;
    }).join('\n');
  }

  /**
   * @method loadController
   * @param {String} controllerName
   *
   * @private
   */
  function loadController( controllerName ){

    if( controllerName in loaded )
      return loaded[controllerName];

    if( controllerName in stack ){
      loaded[controllerName] = stack[controllerName]( caminio, policies, middleware );
      return loaded[controllerName];
    }

  }

  /**
   * sets controllerName, actionName
   * in the req object. This is mainly used for logging but can be helpful
   * for many other use cases
   *
   * @private
   */
  function setControllerAndActionNames( type, route, controllerName, actionName ){
    return function( req, res, next ){
      res.locals.controllerName = req.controllerName = controllerName;
      res.locals.actionName = req.actionName = actionName;
      res.locals.routeName = req.routeName = route;
      res.locals.env = caminio.env;
      res.locals.siteVersion = JSON.parse( fs.readFileSync( join( process.cwd(), 'package.json' ) ) ).version;
      res.locals.caminioVersion = JSON.parse( fs.readFileSync( join( __dirname, '..', '..', 'package.json' ) ) ).version;
      res.locals.site = caminio.config.site || { name: 'camin.io' };
      res.locals.caminioHostname = caminio.config.hostname || (req.protocol + ': //' + req.get('host'));
      res.header('Access-Control-Allow-Origin', req.headers.origin || '*');
      res.header('X-Powered-By', 'caminio');
      next();
    };
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

  /**
   * @method setControllerAuthPolicies
   * @param {Array} actions
   * @param {Object} controller
   * @param {String} controllerAction
   * @return {Array} actions
   * @private
   */
  function setControllerAuthPolicies( actions, controller, controllerAction ){

    if( !('_policies' in controller) ) return actions;
    _.each( controller._policies, function( actionFn, controllers ){

      if( controllers[0] !== '*' && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( controllers.match(/^\*\!/) && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) >= 0 )
        return;

      if( controllers[0] !== '*' && controllers.replace(/[\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( !actionFn )
        caminio.logger.error('controller action or policy unknown', Object.keys(controller._policies), controllerAction);

      if( actionFn instanceof Array )
        actionFn.forEach(function(action){ actions.push(action); });
      else
        actions.push( actionFn );
      
    });

    return actions;
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
      if( controllers[0] !== '*' && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( controllers.match(/^\*\!/) && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) >= 0 )
        return;

      if( controllers[0] !== '*' && controllers.replace(/[\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( !actionFn )
        caminio.logger.error('controller action or policy unknown', Object.keys(controller._policies), controllerAction);

      if( actionFn instanceof Array )
        actionFn.forEach(function(action){ actions.push(action); });
      else
        actions.push( actionFn );
    });

    return actions;
  }

  /**
   * intercept actions flow before sending response (last action)
   *
   * @method setInterceptResponseActions
   * @param {Array} actions
   * @param {Object} controller
   * @param {String} controllerAction
   * @return {Array} actions
   * @private
   */
  function setInterceptResponseActions( actions, controller, controllerAction ){
   if( !('_beforeResponse' in controller) ) return actions;
    _.each( controller._beforeResponse, function( actionFn, controllers ){
      if( controllers[0] !== '*' && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( controllers.match(/^\*\!/) && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) >= 0 )
        return;

      if( controllers[0] !== '*' && controllers.replace(/[\ ]*/g,'').split(',').indexOf(controllerAction) < 0 )
        return;

      if( !actionFn )
        caminio.logger.error('controller action or policy unknown', Object.keys(controller._policies), controllerAction);

      if( actionFn instanceof Array )
        actionFn.forEach(function(action){ actions.push(action); });
      else
        actions.push( actionFn );
    });

    return actions; 
  }

  function testValid( actions ){
    actions.forEach( function(action, index){
      if( index === 0 && typeof(action) !== 'string' )
        throw Error('first object must be a function');
      if( index > 0 && typeof(action) !== 'function' )
        throw Error('argument must be a function: '+util.inspect(actions));
    });
    return true;
  }


}
