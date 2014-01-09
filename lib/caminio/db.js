/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path')
  , Connection = require('./db/connection')
  , modelRegistry = require('./db/model_registry')
  , logger = require('./logger');


var db = {};

db.Connection = Connection;
db.modelRegistry = modelRegistry;

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

module.exports = db;
