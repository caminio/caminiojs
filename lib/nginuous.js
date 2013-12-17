/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , mongoose = require('mongoose');

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

nginuous.orm = mongoose;

// a gear
nginuous.Gear = Gear;

// make nginuous itself a gear
new Gear({
  absolutePath: path.normalize( path.join( __dirname, '..' ) )
});

module.exports = nginuous;
