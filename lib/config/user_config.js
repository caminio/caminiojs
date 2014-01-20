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
  , join          = require('path').join;

module.exports = function( caminio ){

  if( !fs.existsSync( caminio.config.paths.config ) )
    throwMissing( caminio.config.paths.config, true );

  /**
   * database adapters
   */
  loadConfig( 'adapters' );

  /**
   * session settings
   */
  loadConfig( 'session' );

  /**
   * session settings
   */
  loadConfig( 'routes' );

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



  function loadConfig( str ){
    var adaptersPath = join( caminio.config.paths.config, str+'.js' );
    if( !fs.existsSync( adaptersPath ) )
      throwMissing( adaptersPath );
    caminio.config[str] = require( adaptersPath )[str];
  }


  function throwMissing( pth, directory ){
    if( directory )
      throw Error( 'missing directory '+pth );
    throw Error( 'missing file '+pth );
  }

}