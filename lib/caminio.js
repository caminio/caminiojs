/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

var path = require('path')
  , mongoose = require('mongoose')
  , loginMW = require('connect-ensure-login')

var Application = require('./caminio/application')
  , Gear = require('./caminio/gear')
  , Controller = require('./caminio/controller')
  , utils = require('./caminio/utils')
  , views = require('./caminio/views')
  , logger = require('./caminio/logger')
  , router = require('./caminio/router');

/**
The Main caminio module container
Create a new instance of caminio to
create an application

@module caminio
@class caminio

@param {Object} options option object (Will override options set in config/environment/<NODE_ENV>.js
@param {Object} options.port The port to listen to
@param {Object} options.auth_token_timeout_min Timout in minutes for auth token (if not specified by api request)
@return {Application} an Application object

@example 
    var app = caminio();
 **/
function caminio( options ){

  if( !caminio.app ) // only create one instance in a process!
    caminio.app = new Application( options );
  return caminio.app;

}

/**
 * @property router
 * @type Object
 **/
caminio.router = router;

/**
 * shortcut to Controller class
 *
 * @property Controller
 **/
caminio.Controller = Controller;

/**

@property utils

**/
caminio.utils = utils;

/**
 *
 * @property app
 **/
caminio.app;

/**
The Object Relation mapper
(deprecated. Use db instead)
@property orm
@deprecated
**/
caminio.orm = mongoose;

/**
The database connection mapper
in this case: mongoosejs

@property db
@type Object
**/
caminio.db = mongoose;

/**
Utilities for caminio

@property utils
@type Object
**/
caminio.utils = utils;

/**
 * Logger
 * @property logger
 * @type Object
 **/
caminio.logger = logger;

/**
 * connect-login middleware mapper
 * @property login
 * @type Object
 **/
caminio.login = loginMW;

/**
View helpers

@property views
@type Object
**/
caminio.views = views;

// a gear
caminio.Gear = Gear;

module.exports = caminio;
