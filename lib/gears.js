/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

module.exports = function( caminio ){
  
  var gears = caminio.gears = {};

  gears.store = {};

  gears.register = function registerGear( gear ){
    gears.store[ gear.name ] = gear;
  }

  return gears;

}