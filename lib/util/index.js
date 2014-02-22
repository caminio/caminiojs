var _             = require('lodash');

/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */
module.exports.makeOptional = function( arg ){
}

/**
* Return a unique identifier with the given `len`.
*
* utils.uid(10);
* // => "FDaS435D2z"
*
* @param {Number} len
* @return {String}
*/
module.exports.uid = function(len){
  len = len || 8;
  var buf = []
    , chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    , charlen = chars.length;

  for (var i = 0; i < len; ++i) {
    buf.push(chars[getRandomInt(0, charlen - 1)]);
  }

  return buf.join('');
};


module.exports.capitalize = function capitalize( str ) {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
};

/**
 * formats mongoose error messages into
 * ember-data readable syntax
 *
 * @method formatErrors
 * @param {Object} err Mongoose Error object
 */
module.exports.formatErrors = function formatErrors( err ){
  console.log('err', err);
  return { 
    errors: _.transform(err.errors, function(result,values,key){ 
      if( values.type === 'user defined' )
        result[key] = values.message;
      else
        result[key] = values.type; 
    }), 
    message: 'validation_failed' 
  };
};

/**
 * Retrun a random int, used by `utils.uid()`
 *
 * @param {Number} min
 * @param {Number} max
 * @return {Number}
 * @private
 */
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}


//
// this is a very clever hack from
// http://stackoverflow.com/questions/13227489
// to find out the absolute path
// to the caller
module.exports.getCaller = function getCaller() {
  var stack = getStack()

  // Remove superfluous function calls on stack
  stack.shift() // getCaller --> getStack
  stack.shift() // omfg --> getCaller

  // Return caller's caller
  return stack[1].receiver
}

/**
 * @private
 */
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
