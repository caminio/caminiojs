/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , gearRegistry = require('./gear_registry');

/**
 * a gear is a plugin for nginios. You can either write just
 * a simple library providing extra functionality or use it
 * like a rails engine and use relative the the file where new Gear()
 * is instantitiated.
 *
 * In Version 1, the following directories will be parsed:
 * * app/models
 * * app/controllers
 * * app/middleware
 * 
 * @class Gear
 * @constructor
 * @param {Object} options
 * @param {String} options.absolutePath [optional] the absolute path to be used to parse the app directory
 * @param {String} options.name [optional] an alternative name to be used for this gear. By default, the filename
 * of the gear will be used
 *
 **/
function Gear( options ){
  options = options || {};
  var caller = getCaller();
  /**
   * @property absolutePath
   * @type String
   * @default [dirname of the file where new Gear() is called]
   **/
  this.absolutePath = options.absolutePath || path.dirname( caller.filename );
  /**
   * @property name
   * @type String
   * @default [filename where new Gear() is called]
   **/
  this.name = path.basename( this.absolutePath );
  gearRegistry[this.name] = this;
}

module.exports = Gear;

//
// this is a very clever hack from
// http://stackoverflow.com/questions/13227489
// to find out the absolute path
// to the caller
function getCaller() {
  var stack = getStack()

  // Remove superfluous function calls on stack
  stack.shift() // getCaller --> getStack
  stack.shift() // omfg --> getCaller

  // Return caller's caller
  return stack[1].receiver
}

function getStack() {
  // Save original Error.prepareStackTrace
  var origPrepareStackTrace = Error.prepareStackTrace

  // Override with function that just returns `stack`
  Error.prepareStackTrace = function (_, stack) {
    return stack;
  }

  // Create a new `Error`, which automatically gets `stack`
  var err = new Error()

  // Evaluate `err.stack`, which calls our new `Error.prepareStackTrace`
  var stack = err.stack

  // Restore original `Error.prepareStackTrace`
  Error.prepareStackTrace = origPrepareStackTrace

  // Remove superfluous function call on stack
  stack.shift() // getStack --> Error

  return stack;
}
