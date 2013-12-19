/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path');

var db = require('./db')
  , logger = require('./logger')
  , controllerRegistry = require('./controller_registry');

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
  loadAppMiddleware( gear, path.join( appPath, 'middleware' ) );
  loadAppRoutes( path.join( appPath, 'controllers' ) );

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

  recursiveLoadAppRoutes( routesPath, '' );

}

/**
 * recursively loads app/controllers directory
 * a controller parsed in a directory
 * is namespaced with the directory's name
 *
 */
function recursiveLoadAppRoutes( routesPath, ns ){
  fs
    .readdirSync( routesPath )
    .forEach(function(file) {
      var absPath = path.join( routesPath, file );
      if( file.indexOf('.js') > 0 )
        return controllerRegistry.register( path.join( ns, path.basename(file).replace('.js','') ), require( absPath ) );
      if( fs.statSync( absPath ).isDirectory() )
        recursiveLoadAppRoutes( absPath, path.join( ns, path.basename(absPath) ) );
    });
}

/**
 * read app/middleware
 *
 * @param {Gear} the gear to be filled with middleware modules
 * @param {String} path to middleware
 *
 * @api private
 */
function loadAppMiddleware( gear, middlewarePath ){

  if( !fs.existsSync( middlewarePath ) )
    return;

  fs
    .readdirSync( middlewarePath )
    .filter(function(file) {
      return file.indexOf('.js') > 0
    })
    .forEach(function(file) {
      try{
        gear[ path.basename(file).replace('.js','') ] = require( path.join( middlewarePath, file ) );
      }catch(e){
        logger.error('gear', 'your middleware in ' + path.join(middlewarePath,file) + ' failed to compile' );
        throwErrorByLoading( path.join(middlewarePath,file) );
      }
    });

}

/**
 * tiny helper to throw error, again
 * but this time, stack trace can be tracked back
 * into the module which caused the actual error
 *
 * @api private
 */
function throwErrorByLoading( pth ){
  require( pth );
}

module.exports = GearFactory;
