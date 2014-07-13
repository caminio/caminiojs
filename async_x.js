/* jshint node: true */
/* jshint expr: true */
'use strict';

/**
 * @module AsyncX
 */
module.exports = exports = {
  
  /**
   * @method apply
   * @param {Function} fn the function to execute
   * @param {Object} obj the object to be applied to function
   * @param {anything} anything else is applied to the function call
   *
   * prepares a function call which provides given value as this
   *
   */
  applyThis: function(fn, obj) {
    var args = Array.prototype.slice.call(arguments, 2);
    return function () {
      return fn.apply(
        obj, args.concat(Array.prototype.slice.call(arguments))
      );
    };
  }

};
