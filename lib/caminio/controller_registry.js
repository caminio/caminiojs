/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var controllerRegistry = {};

controllerRegistry.controllers = {};

/**
 * define a new controller
 *
 * @api private
 */
controllerRegistry.register = function registerController( gear, name, controller ){
  controllerRegistry.controllers[name] = { gear: gear, controller: controller };
}

module.exports = controllerRegistry;
