/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash');

module.exports = function( caminio ){

  var registeredRoutes = []
    , loaded = {}
    , stack = {}
    , policies = {}
    , middleware = {};

  return {
    stack: stack,
    policies: policies,
    middleware: middleware,
    routes: routes,
    registerRoute: registerRoute,
    createRoute: createRoute,
    load: loadController
  }


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

      var controller = loadController(controllerName);

      if( !(controllerAction in controller) )
        return caminio.logger.warn('controller', controllerName, 'has no action', controllerAction);

      registerRoute( type, route, controllerName, controllerAction );

      var actions = [ route ];
      actions.push( setControllerAndActionNames(type, route, controllerName, controllerAction) );
      actions = setGlobalBeforeActions( actions );
      actions = setControllerBeforeActions( actions, controller, controllerAction );
      actions = actions.concat( controller[controllerAction] );
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
      res.locals.caminioHostname = req.protocol + "://" + req.get('host');
      next();
    }
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
      if( ( controllers[0] === '*' && controllers.replace(/[\*\!\(\)\ ]*/g,'').split(',').indexOf(controllerAction) < 0 ) || 
        controllers.replace(/[\ ]*/g,'').split(',').indexOf(controllerAction) >= 0 ){
        if( actionFn instanceof Array )
          actionFn.forEach(function(action){ actions.push(action); });
        else
          actions.push( actionFn );
      }
    });

    return actions;
  }


}