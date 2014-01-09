/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path')
  , mongoose = require('mongoose')
  , S = require('string')
  , logger = require('../logger');


var modelRegistry = {};

modelRegistry.modelPaths = [];

/**
 * register a model path
 * @param {String} - the path to the directory holding the modles
 */
modelRegistry.registerModelPath = function registerModelPath( path ){
  if( fs.existsSync( path ) )
    this.modelPaths.push( path );
  else{
    logger.error('db', 'path ' + path + 'not found when trying to register db model');
    throw Error('model path could not be registered: ' + path)
  }
};

/**
 * loadModels
 *
 * loads all models which have been registered vai registerModelPath
 */
modelRegistry.loadModels = function loadModels(){
  var loadedModels = [];
  this.modelPaths
    .forEach( function( filePath ){
      fs
        .readdirSync( filePath )
        .filter(function(file) {
          return file.indexOf('.js') > 0
        })
        .forEach(function(file) {
          var name = path.basename(file.replace('.js',''));
          try{
            mongoose.model( S(name).capitalize().camelize().s, require( path.join( filePath, file ) ) );
          } catch( e ){
            logger.error('db', 'your model in ' + path.join(filePath,file) + ' failed to compile' );
            throwErrorByLoading( path.join(filePath,file) );
          }
          loadedModels.push( name );
        });
    });
  logger.info('db', 'loaded ' + loadedModels.length + ' models: [' + loadedModels.join( ',') + ']');
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

module.exports = modelRegistry;
