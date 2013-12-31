/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

var path = require('path')
  , mongoose = require('mongoose');

var Application = require('./nginios/application')
  , Gear = require('./nginios/gear')
  , Controller = require('./nginios/controller')
  , utils = require('./nginios/utils')
  , views = require('./nginios/views')
  , router = require('./nginios/router');

/**
The Main nginios module container
Create a new instance of nginios to
create an application

@module nginios
@class nginios

@param {Object} options option object (Will override options set in config/environment/<NODE_ENV>.js
@param {Object} options.port The port to listen to
@param {Object} options.auth_token_timeout_min Timout in minutes for auth token (if not specified by api request)
@return {Application} an Application object

@example 
    var app = nginios();
 **/
function nginios( options ){

  if( !nginios.app ) // only create one instance in a process!
    nginios.app = new Application( options );
  return nginios.app;

}

/**
 * @property router
 * @type Object
 **/
nginios.router = router;

/**
 * shortcut to Controller class
 *
 * @property Controller
 **/
nginios.Controller = Controller;

/**

@property utils

**/
nginios.utils = utils;

/**
 *
 * @property app
 **/
nginios.app;

/**
The Object Relation mapper
(deprecated. Use db instead)
@property orm
@deprecated
**/
nginios.orm = mongoose;

/**
The database connection mapper
in this case: mongoosejs

@property db
@type Object
**/
nginios.db = mongoose;

/**
Utilities for nginios

@property utils
@type Object
**/
nginios.utils = utils;

/**
View helpers

@property views
@type Object
**/
nginios.views = views;

// a gear
nginios.Gear = Gear;

// make nginios itself a gear
new Gear({
  absolutePath: path.normalize( path.join( __dirname, '..' ) )
});

module.exports = nginios;
