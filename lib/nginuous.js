/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

var path = require('path')
  , mongoose = require('mongoose');

var Application = require('./nginuous/application')
  , Gear = require('./nginuous/gear')
  , Controller = require('./nginuous/controller')
  , utils = require('./nginuous/utils')
  , router = require('./nginuous/router');

/**
The Main nginuous module container
Create a new instance of nginuous to
create an application

@module nginuous
@class nginuous

@param {Object} options option object (Will override options set in config/environment/<NODE_ENV>.js
@param {Object} options.port The port to listen to
@param {Object} options.auth_token_timeout_min Timout in minutes for auth token (if not specified by api request)
@return {Application} an Application object

@example 
    var app = nginuous();
 **/
function nginuous( options ){

  if( !nginuous.app ) // only create one instance in a process!
    nginuous.app = new Application( options );
  return nginuous.app;

}

/**
 * @property router
 * @type Object
 **/
nginuous.router = router;

/**
 * shortcut to Controller class
 *
 * @property Controller
 **/
nginuous.Controller = Controller;

/**

@property utils

**/
nginuous.utils = utils;

/**
 *
 * @property Object
 **/
nginuous.app;

nginuous.orm = mongoose;

// a gear
nginuous.Gear = Gear;

// make nginuous itself a gear
new Gear({
  absolutePath: path.normalize( path.join( __dirname, '..' ) )
});

module.exports = nginuous;
