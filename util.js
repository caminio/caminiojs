/* jslint node: true */
'use strict';

module.exports.mixin = function extend(destination, source) {
  for (var k in source)
    if (source.hasOwnProperty(k))
      destination[k] = source[k];
  return destination;
};
