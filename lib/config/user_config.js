/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash');
var fs            = require('fs');
var join          = require('path').join;

module.exports = function( caminio ){

  if( !fs.existsSync( caminio.config.paths.config ) )
    throwMissing( caminio.config.paths.config, true );

  /**
   * database adapters
   */
  //loadConfig( 'adapters' );

  /**
   * session settings
   */
  loadConfig( 'session' );

  /**
   * token settings
   */
  loadConfig( 'token' );

  /**
   * csrf settings
   */
  loadConfig( 'csrf', true );

  /**
   * csrf settings
   */
  loadConfig( 'mailer', true );

  /**
   * csrf settings
   */
  loadConfig( 'audit', true );

  /**
   * session settings
   */
  loadConfig( 'routes' );

  /**
   * session site
   */
  loadConfig( 'site', true );

  /**
   * environment settings
   */
  _.merge( caminio.config, require( join(caminio.config.paths.config, 'environments', caminio.env) ) );

  // errors
  caminio.config.errors = {};
  var errorsPath = join(caminio.config.paths.config,'errors');
  if( fs.existsSync( errorsPath ) ){
    fs
      .readdirSync( errorsPath )
      .forEach( function( file ){
        var name = file.replace('.js','');
        caminio.config.errors[name] = require( join(errorsPath,file) )( caminio );
      });
  }

  // loggers
  loadConfig('loggers', true);

  function loadConfig( str, skipError ){
    var adaptersPath = join( caminio.config.paths.config, str+'.js' );
    if( !fs.existsSync( adaptersPath ) ){
      if( skipError ){ return; }
      throwMissing( adaptersPath );
    }
    caminio.config[str] = require( adaptersPath )[str];
  }


  function throwMissing( pth, directory ){
    if( directory )
      throw Error( 'missing directory '+pth );
    throw Error( 'missing file '+pth );
  }

};
