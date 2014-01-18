/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var flash = require('connect-flash');

module.exports = function ServerSetup( caminio, app ){

  app.use( flash() );

}
