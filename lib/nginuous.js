/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var Application = require('./nginuous/application')
  , Gear = require('./nginuous/gear');

var app;

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

  if( !app ) // only create one instance in a process!
    app = new Application( options );
  return app;

}

// a gear - plugin
nginuous.Gear = Gear;

module.exports = nginuous;
