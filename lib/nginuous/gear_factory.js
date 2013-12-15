/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path');

var db = require('./db')
  , logger = require('./logger');

var GearFactory = {};

GearFactory.process = function processGear( gear ){
  
  if( !GearFactory.app )
    throw Error('no app object present');

  readAndLoadAppPaths( gear );

}

/**
 * check if the gear has an app directory
 * and read in models and routes
 *
 * @api private
 */
function readAndLoadAppPaths( gear ){
  
  if( !fs.existsSync( gear.absolutePath ) )
    throw Error('gear does not have an absolute path set: ', gear.absolutePath )

  var appPath = path.join( gear.absolutePath, 'app' );

  if( !fs.existsSync( appPath ) )
    return logger.info('gear', 'skipping /app path as it does not exist ('+appPath+')');

  loadAppModels( path.join( appPath, 'models' ) );
  loadAppRoutes( path.join( appPath, 'routes' ) );

}

/**
 * read app/models
 *
 * @api private
 */
function loadAppModels( modelPath ){

  if( !fs.existsSync( modelPath ) )
    return;

  db.modelRegistry.registerModelPath( modelPath );

}

/**
 * read app/routes
 *
 * @api private
 */
function loadAppRoutes( routesPath ){

  if( !fs.existsSync( routesPath ) )
    return;

  // TODO: register routes and think about clever way
  // to order them

}

module.exports = GearFactory;
