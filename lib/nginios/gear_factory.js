/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path');

var db = require('./db')
  , logger = require('./logger')
  , views = require('./views')
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
  loadAppControllers( path.join( appPath, 'controllers' ) );
  loadAppViews( path.join( appPath, 'views' ) );

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
function loadAppControllers( routesPath ){

  if( !fs.existsSync( routesPath ) )
    return;

  recursiveLoadAppControllers( routesPath, '' );

}

/**
 * recursively loads app/controllers directory
 * a controller parsed in a directory
 * is namespaced with the directory's name
 *
 */
function recursiveLoadAppControllers( routesPath, ns ){
  fs
    .readdirSync( routesPath )
    .forEach(function(file) {
      var absPath = path.join( routesPath, file );
      if( fs.statSync( absPath ).isDirectory() )
        return recursiveLoadAppControllers( absPath, path.join( ns, path.basename(absPath) ) );
      if( file.indexOf('.js') > 0 )
        try{
          controllerRegistry.register( path.join( ns, path.basename(file).replace('.js','') ), require( absPath ) );
        } catch(e){
          logger.error('gear', 'your controller in ' + absPath + ' failed to compile' );
          throwErrorByLoading( absPath );
        }
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

  read and register views directory

  @class  GearFactory
  @method loadAppViews
  @private

**/
function loadAppViews( viewPath ){

  if( !fs.existsSync( viewPath ) )
    return;

  views.paths.push( viewPath );

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
