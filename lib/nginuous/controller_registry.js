/*
 * nginuous
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
controllerRegistry.register = function registerController( name, controller ){
  controllerRegistry.controllers[name] = controller;
}

module.exports = controllerRegistry;
