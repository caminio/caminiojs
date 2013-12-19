/*
 * nginuous
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
          mongoose.model( S(name).camelize().capitalize().s, require( path.join( filePath, file ) ) );
          loadedModels.push( name );
        });
    });
  logger.info('db', 'loaded ' + loadedModels.length + ' models: [' + loadedModels.join( ',') + ']');
}

module.exports = modelRegistry;
