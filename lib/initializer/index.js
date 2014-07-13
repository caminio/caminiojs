/* jshint node: true */
/* jshint expr: true */
'use strict';

var _               = require('lodash'),
    join            = require('path').join,
    extname         = require('path').extname,
    inflection      = require('inflection'),
    async           = require('async'),
    fs              = require('fs');

var Controller      = require('../controller'),
    asyncx          = require('../../async_x'),
    router          = require('../router');

/**
 * @module Initializer
 */
module.exports = exports = {

  init: function( cb ){
 
    var app = this;

    // initialization process starts here
    async.series([
      asyncx.applyThis( initEngines, app ),
      asyncx.applyThis( initApp, app )
    ], cb);

  }

};


// PRIVATE

/**
 * @method initEngines
 */
function initEngines( done ){
  done();
}

/**
 * @method initApp
 */
function initApp( done ){
  var app = this;
  loadModels.call(app, join(app.root,'app','models'));
  loadControllers.call(app, join(app.root,'app','controllers'));
  loadRoutes.call(app, join(app.root,'config','routes.js'));
  done();
}


function loadModels( dirname ){
  /* jshint validthis: true */
  if( !this.db )
    return this.logger.warn('no db adapter is present. app/models skipped.');
  if( !fs.existsSync( dirname ) )
    return caminio.logger.debug('skipping models of', dirname, 'as it does not exist');
  loadFiles.call(this, dirname );
}

function loadControllers( dirname ){
  /* jshint validthis: true */
  var app = this;
  app.controllers = {};

  if( !fs.existsSync( dirname ) )
    return app.logger.debug('skipping controllers of', dirname, 'as it does not exist');

  loadFiles.call(app, dirname, function( fn ){
    var controllerName = inflection.underscore(fn.name).replace('_controller','');
    app.controllers[controllerName] = new Controller( fn.name, app );
    fn.call( app.controllers[controllerName] );
  });

}

function loadRoutes( filename ){
  /* jshint validthis: true */
  var app = this;
  if( !fs.existsSync(filename) )
    return;
  var routes = require( filename );
  _.each( routes, function( controllerAction, path ){
    router.create( path, controllerAction, filename, app );
  });
}

function loadFiles( absPath, processFn ){
  /* jshint validthis: true */
  fs
    .readdirSync( absPath )
    .filter( function(filename){
      return extname(filename) === '.js';
    })
    .forEach( function(filename){
      var fn = require( join( absPath, filename ) );
      if( typeof(fn) !== 'function' )
        throw new Error(join( absPath, filename )+': must export a function');
      if( typeof(fn.name) !== 'string' )
        throw new Error(join( absPath, filename )+': must return a named function (currently returns anonymous function)');
      if( inflection.underscore(fn.name) !== filename.replace(extname(filename),'') )
        throw new Error(join( absPath, filename )+': does not match returned function name ('+fn.name+')');
      processFn( fn );
    });
}
