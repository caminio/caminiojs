/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

var path = require('path')
  , mongoose = require('mongoose');

var Application = require('./nginious/application')
  , Gear = require('./nginious/gear')
  , Controller = require('./nginious/controller')
  , utils = require('./nginious/utils')
  , router = require('./nginious/router');

/**
The Main nginious module container
Create a new instance of nginious to
create an application

@module nginious
@class nginious

@param {Object} options option object (Will override options set in config/environment/<NODE_ENV>.js
@param {Object} options.port The port to listen to
@param {Object} options.auth_token_timeout_min Timout in minutes for auth token (if not specified by api request)
@return {Application} an Application object

@example 
    var app = nginious();
 **/
function nginious( options ){

  if( !nginious.app ) // only create one instance in a process!
    nginious.app = new Application( options );
  return nginious.app;

}

/**
 * @property router
 * @type Object
 **/
nginious.router = router;

/**
 * shortcut to Controller class
 *
 * @property Controller
 **/
nginious.Controller = Controller;

/**

@property utils

**/
nginious.utils = utils;

/**
 *
 * @property app
 **/
nginious.app;

/**
The Object Relation mapper
(deprecated. Use db instead)
@property orm
@deprecated
**/
nginious.orm = mongoose;

/**
The database connection mapper
in this case: mongoosejs

@property db
@type Object
**/
nginious.db = mongoose;

/**
Utilities for nginious

@property utils
@type Object
**/
nginious.utils = utils;

// a gear
nginious.Gear = Gear;

// make nginious itself a gear
new Gear({
  absolutePath: path.normalize( path.join( __dirname, '..' ) )
});

module.exports = nginious;
