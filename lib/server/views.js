/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var fs      = require('fs')
  , join    = require('path').join;

module.exports = function views( caminio ){

  /**
   * @class views
   */
  var views = {};

  /**
   * @property paths
   * @type Array
   */
  views.paths = [];

  /**
   * @property assetPaths
   * @type Array
   */
  views.assetPaths = [];

  /**
   * tries to find the given file
   * in registered paths. First match
   * will be returend
   *
   * @method lookup
   * @param {String} file The filename which should be looked up
   * @return {String} the absolute path to the filename if found in any view paths. Otherwise null.
   */
  views.lookup = function getViewPath( file ){
    var res = null;
    if( Object.keys(caminio.config.viewEngines).length < 1 )
      return findPath( file+'.html' );
    return findPath( file );
  }

  function findPath( file ){
    var res = null;
    views.paths.forEach( function(p){
      var absPath = join( p, file )
      if( fs.existsSync(absPath) )
        return res = absPath;
      // TODO: check if requested a html, xml or different
      for( var name in caminio.config.viewEngines ){
        var viewEngine = caminio.config.viewEngines[name];
        viewEngine.ext.forEach( function(ext){
          absPath = absPath + '.html.'+ext;
          if( fs.existsSync(absPath) )   
            return res = absPath;
        });
      }
    });
    return res;
  }
 
  return views;

}