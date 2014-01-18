/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

module.exports = function( caminio ){

  var registeredRoutes = [];

  return {
    routes: routes,
    registerRoute: registerRoute
  }


  function registerRoute( verb, path, controllerName, controllerAction ){

    registeredRoutes.push({ 
      path: path, 
      verb: verb, 
      controllerName: controllerName, 
      controllerAction: controllerAction 
    });

  }

  function routes(){
    return registeredRoutes.map( function(route){
      return route.path + ' ' + route.verb.toUpperCase() + ' ' + route.controllerName + '#' + route.controllerAction;
    }).join('\n');
  }

}