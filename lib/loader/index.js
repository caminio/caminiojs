/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash')
  , fs            = require('fs')
  , inflection    = require('inflection')
  , join          = require('path').join
  , extname       = require('path').extname
  , basename      = require('path').basename;

var util          = require('../util');

module.exports = function( caminio ){

  caminio.logger.debug('loader initializing', 
    _.keys(caminio.gears).length, 'gears in order:', 
    _.keys(caminio.gears).map(function(gearName){ return gearName.replace('caminio-',''); }).join(',')
  );

  caminio.hooks = require('./hooks')( caminio );
 
  return {
    collectConfig: collectConfig,
    collectModels: collectModels,
    collectPolicies: collectPolicies,
    collectMiddleware: collectMiddleware,
    collectControllers: collectControllers,
    collectHooks: collectHooks,
    collectViews: collectViews
  }

  function collectConfig( cb ){
    
    _.each( caminio.gears, function( gear ){
      
      if( !gear.api ) return;

      var configDir = join(gear.paths.absolute,'config');

      // if config dir does not exist, return silently
      if( !fs.existsSync( configDir ) ) return;

      // routes.js
      var routesConfig = join(configDir,'routes.js');
      if( fs.existsSync( routesConfig ) )
        _.merge( caminio.config.routes, require(routesConfig).routes );

      // i18n
      var i18nPath = join(configDir,'i18n');
      if( fs.existsSync( i18nPath ) )
        caminio.i18n.paths.push( i18nPath );

    });

    cb();

  }

  function collectHooks( cb ){
    
    _.each( caminio.gears, function( gear ){
      
      var hooksDir = join(gear.paths.absolute,'config','hooks');

      // if config dir does not exist, return silently
      if( !fs.existsSync( hooksDir ) ) return;
  
      fs
        .readdirSync( hooksDir )
        .forEach( function( file ){
          require( join(hooksDir,file) )( caminio );
        });

    });

    cb();

  }
 
  function collectModels( cb ){

    var orm           = require('./orm')( caminio )
      , models        = [];
    
    _.each( caminio.gears, function( gear ){
      
      if( !gear.api ) return;

      if( !fs.existsSync( gear.paths.api ) )
        return caminio.logger.warn('gear ' + gear.name + ' propagates api but has no api folder');

      var modelsPath = join( gear.paths.api, 'models' );
      // exit silent if no models path
      if( !fs.existsSync( modelsPath ) )
        return;

      collectRecursivePath( modelsPath, '', models, true );

    });

    orm.init( models, cb );

  }

  /**
   * @method collectControllers
   * @param {Function} cb callback being passed on as is to controllers.init
   * @param {Object} result from async.auto. Should be an object containing keys
   * of the previously called collectedMiddleware and collectedPolicies
   */
  function collectControllers( cb, result ){

    var controllers   = require('./controllers')( caminio )
      , ctrls        = {};

    _.each( caminio.gears, function( gear ){

      if( !gear.api ) return;

      var ctrlsPath = join( gear.paths.api, 'controllers' );
      // exit silent if no models path
      if( !fs.existsSync( ctrlsPath ) )
        return;

      collectRecursivePath( ctrlsPath, '', ctrls, true );

    });

    controllers.init( ctrls, result.collectMiddleware, result.collectPolicies, cb );
  }

  /**
   * @method collectMiddleware
   * @param {Function} cb callback
   */
  function collectMiddleware( cb ){

    var middleware      = {};

    _.each( caminio.gears, function( gear ){

      if( !gear.api ) return;

      var mwPath = join( gear.paths.api, 'middleware' );
      // exit silent if no middleware
      if( !fs.existsSync( mwPath ) )
        return;

      collectRecursivePath( mwPath, '', middleware, true, true );

    });

    cb( null, middleware );
  }

  /**
   * @method collectPolicies
   * @param {Function} cb callback
   */
  function collectPolicies( cb, result ){

    var policies      = {};

    _.each( caminio.gears, function( gear ){

      if( !gear.api ) return;

      var policiesPath = join( gear.paths.api, 'policies' );
      // exit silent if no policies
      if( !fs.existsSync( policiesPath ) )
        return;

      collectRecursivePath( policiesPath, '', policies, true, true );

    });

    cb( null, policies );

  }

  /**
   * @method collectViews
   * @param {Function} cb callback
   */
  function collectViews( cb ){

    _.each( caminio.gears, function( gear ){

      if( !gear.api ) return;

      var viewsPath = join( gear.paths.api, 'views' );

      if( fs.existsSync( viewsPath ) )
        caminio.views.paths.push( viewsPath );

      var assetsPath = join( gear.paths.api, 'assets' );

      if( fs.existsSync( assetsPath ) )
        caminio.views.assetPaths.push( assetsPath );

    });

    cb();

  }

  /**
   * @private
   */
  function collectRecursivePath( path, ns, stack, load, camelCase ){

    fs
      .readdirSync( path )
      .forEach( function( file ){

        var absPath = join( path, file );
        if( fs.statSync( absPath ).isDirectory() ){
          if( file[0] === '_' )
            return; // skip paths starting with underscore
          return collectRecursivePath( absPath, join( ns, util.capitalize(basename(absPath)) ), stack, load, camelCase );
        }
        
        if( extname( file ) === '.js' ){
          var name = inflection.classify( join( ns, util.capitalize(basename(file).replace('.js','')) ).replace(/\//g,'::') );
          name = camelCase ? name[0].toLowerCase()+name.substr(1,name.length-1) : name;
          if( load ){
            var loadedFile = camelCase ? require( absPath )( caminio ) : require( absPath );
            if( typeof(loadedFile) === 'undefined' )
              return caminio.logger.debug('WARNING: file', file, 'did not return a middleware object. Skipped adding to stack');
            if( !loadedFile )
              return; // silent return as null return is ok
            loadedFile._name = name;
            loadedFile._absolutePath = absPath;
            stack[name] = loadedFile;
          } else 
            stack.push({ name: name, path: absPath });
        }
      });

  }

}