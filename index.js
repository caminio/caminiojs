/* jshint node: true */
/* jshint expr: true */
'use strict';

var Caminio     = require('./lib/caminio');

/**
 * @method caminio
 * @return {Caminio} caminio instance
 */
module.exports = exports = function(){
  
  return new Caminio();

};
