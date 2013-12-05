/**
 * module dependencies
 */

var Application = require('./nginuous/application');

/**
 * get a new instance of nginuous to
 * create an application
 * 
 * @params [options] {Object} options
 * * port - the port to listen when starting the server
 *
 * @example var app = nginuous();
 */
function nginuous( options ){

  return new Application( options );

}

module.exports = nginuous;
