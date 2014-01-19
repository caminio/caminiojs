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
    views.paths.forEach( function(p){
      var absPath = join( p, file )
      if( fs.existsSync(absPath) )
        return res = absPath;
      absPath = absPath+'.ejs';
      if( fs.existsSync(absPath) )   
        return res = absPath;
      if( fs.existsSync(absPath) )   
        return res = absPath;
    });
    res = res || '404.ejs';
    caminio.logger.info('rendering view: ' + res);
    return res;                      
  }                                  
 
  return views;

}