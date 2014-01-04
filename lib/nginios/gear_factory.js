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
  , router = require('./router')
  , controllerRegistry = require('./controller_registry');

var GearFactory = {};

GearFactory.process = function processGear( gear ){
  
  if( !GearFactory.app )
    throw Error('no app object present');

  readAndLoadAppPaths( gear );

}

GearFactory.getApplicationsForUser = function getApplicationsForUser( app_gears, user, domain, i18n ){
  var gears = [];
  for( var gearName in app_gears ){
    var gear = app_gears[gearName];
    if( domain.allowed_gears.indexOf(gear.name) >= 0 ){
      gears.push( gear.toJSON() );
    }
  }
  var apps = [];
  var gear_hbs_attached = false;
  gears.forEach( function(gear){
    for( var i in gear.app_paths ){
      gear.app_paths[i].forEach( function( json_app ){

        // copy json_app object to not make changes to the actual gear
        var app_obj = {};
        for( var j in json_app )
          app_obj[j] = json_app[j];

        app_obj.path = router.resolve( i+'/'+json_app.path, '/', true );
        app_obj.hashed_path = '#'+app_obj.path;
        app_obj.name = i18n.t('gears.paths.'+app_obj.name);
        app_obj.icon = 'fa-'+app_obj.icon;

        if( app_obj.require_manager && !user.isAdmin(domain) )
          return;

        if( app_obj.require_superuser && !user.isSuperUser() )
          return;

        if( app_obj.path ){
          if( !gear_hbs_attached ){
            app_obj.hbs = gear.hbs;
            console.log(gear.hbs);
            gear_hbs_attached = true;
          }
          apps.push( app_obj );
        }else
          logger.error('gears', 'app path is not routed ('+json_app.path+')');
      });
    }
  });

  var keys = Object.keys(apps).sort('position');
  var final_apps = [];
  for( var i=0, key; key=keys[i]; i++ )
    final_apps.push( apps[key] );

  return final_apps;
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
  loadAppHbsFiles( gear, path.join( __dirname+'/../../public/gears/' ) );
  registerStatic( gear );

}

/**
 * register static path (public path) if any
 **/
function registerStatic( gear ){
  var pub = path.join( gear.absolutePath, 'public' );
  if( fs.existsSync(pub) ){
    logger.info('gear', 'static: '+pub);
    gear.staticPath = pub;
  }
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
 * read public/gears
 *
 * @param {Gear} gear the gear
 * @param {String} hbsPath path to handlebars directory
 *
 * @private
 **/
function loadAppHbsFiles( gear, hbsPath ){

  fs
    .readdirSync( hbsPath )
    .forEach(function(file) {
      var absPath = path.join( hbsPath, file );
      if( fs.statSync( absPath ).isDirectory() )
        return loadAppHbsFiles( gear, absPath );
      if( file.indexOf('.hbs') > 0 ){
        gear.hbs = gear.hbs || [];
        gear.hbs.push({ 
          name: path.basename(file).replace('.hbs',''),
          filename: path.join( hbsPath, file ),
          id: (absPath.indexOf('partial') > 0 ? null : path.basename(file).replace('.hbs',''))
        });
      
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
