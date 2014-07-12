/* jshint node: true */
/* jshint expr: true */
'use strict';

var _               = require('lodash'),
    join            = require('path').join,
    extname         = require('path').extname,
    fs              = require('fs');

module.exports = exports = {

  /**
   * @class Caminio
   * @method loadConfig
   * 
   * loads basic configuration for caminio (not configuration for the app)
   */
  loadConfig: function( options ){
  
    this.config = _.merge({}, require('../config/defaults'), options);
    this.config.pkg = require('../../package.json');
    this.env = this.config.env;
    this.root = process.cwd();
    this.version = this.config.pkg.version;

  },

  /**
   * @class Caminio
   * @method loadAppConfig
   *
   * loads all app structure and config
   */
  loadAppConfig: function(){
    if( !fs.existsSync( join( this.root, 'app') ) )
      return;
    loadModels.call(this);
    loadControllers.call(this);
  }

};

// PRIVATE

function loadModels(){
  /* jshint validthis: true */
  if( !this.db )
    return this.logger.warn('no db adapter is present. app/models skipped.');
  loadFiles.call(this, join( this.root, 'app', 'models' ) );
}

function loadControllers(){
  /* jshint validthis: true */
  loadFiles.call(this, join( this.root, 'app', 'controllers' ) );
}

function loadFiles( absPath ){
  /* jshint validthis: true */
  var app = this;
  return fs
    .readdirSync( absPath )
    .filter( function(filename){
      return extname(filename) === '.js';
    })
    .forEach( function(filename){
      var modelFn = require( join( absPath, filename ) );
      if( typeof(modelFn) !== 'function' )
        throw new Error(filename+': must export a function');
      modelFn.call(app);
    });
}
