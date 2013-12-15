/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , gearRegistry = require('./gear_registry');

/**
 * Gear
 *
 * a gear is a plugin for nginuous
 * @param {Object} options
 */
function Gear( options ){
  options = options || {};
  var caller = getCaller();
  this.absolutePath = options.absolutePath || path.dirname( caller.filename );
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
    return stack
  }

  // Create a new `Error`, which automatically gets `stack`
  var err = new Error()

  // Evaluate `err.stack`, which calls our new `Error.prepareStackTrace`
  var stack = err.stack

  // Restore original `Error.prepareStackTrace`
  Error.prepareStackTrace = origPrepareStackTrace

  // Remove superfluous function call on stack
  stack.shift() // getStack --> Error

  return stack
}
