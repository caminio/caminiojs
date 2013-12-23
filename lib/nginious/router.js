/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var logger = require('./logger')
  , S = require('string')
  , controllerRegistry = require('./controller_registry');


var router = {};
var routesOrder = {};

/**
 * setup routes
 *
 * @example
 *
 *    router.add( '/users', 'users' );
 *
 */
router.add = function addRoute( url, controller ){
  if( arguments.length === 1 ){
    controller = url;
    url = '/'+controller;
  }
  if( !controller || !( controller in controllerRegistry.controllers ) )
    throw new Error('unknown controller name', controller);
  routesOrder[url] = controller;
}

/**
 * initializes routes
 *
 * @param {Application} the nginious instantiated application
 *
 * @api private
 *
 */
router.init = function initRoutes( app ){
  for( var i in routesOrder ){
    new controllerRegistry.controllers[routesOrder[i]]( i, S(routesOrder[i]).capitalize().s+'Controller', app );
    logger.info('router', i);
  }
  //console.log(app.express.routes);
}

module.exports = router;
