/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path')
  , Connection = require('./db/connection')
  , logger = require('./logger');


var db = {};

db.Connection = Connection;

db.plugins = {};

/**
 * only import plugins with .mongoose_plugin suffix
 */
fs
  .readdirSync(__dirname+'/db/plugins')
  .filter(function(file) {
    return file.indexOf('.mongoose_plugin.js') > 0
  })
  .forEach(function(file) {
    db.plugins[ file.replace('.mongoose_plugin.js','') ] = require( path.join( __dirname, 'db', 'plugins', file ) );
  });

/**
 * register a model path
 * @param {String} - the path to the directory holding the modles
 */
db.registerModelPath = function registerModelPath( path ){
  if( fs.existsSync( path ) )
    modelPaths.push( path );
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
db.loadModels = function loadModels(){
  var loadedModels = [];
  modelPaths
    .forEach( function( filePath ){
      fs
        .readdirSync( filePath )
        .forEach(function(file) {
          require( path.join( filePath, file ) );
          loadedModels.push( path.basename(file.replace('.js','')) );
        });
    });
  logger.info('db', 'loaded models ', loadedModels.join( ', ') );
}

module.exports = db;
