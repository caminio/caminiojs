/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var logger = require('./logger')
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
  if( !controller || !( controller in controllerRegistry.controllers ) )
    throw new Error('unknown controller name', controller);
  routesOrder[url] = controller;
}

/**
 * initializes routes
 *
 * @api private
 *
 */
router.init = function initRoutes( app ){
  for( var i in routesOrder ){
    new controllerRegistry.controllers[routesOrder[i]]( i, app );
    logger.info('router', i);
  }
}

module.exports = router;
