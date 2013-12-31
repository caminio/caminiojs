/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fs = require('fs')
  , path = require('path')
  , logger = require('./logger');

/**
 * @class Views
**/
var views = {};

/**
 * @class Views
 * @property paths
 * @type Array
 **/
views.paths = [];

/**
 * tries to find the given file
 * in registered paths. First match
 * will be returend
 *
 * @class Views
 * @method get
 * @param {String} file The filename which should be looked up
 * @return {String} the absolute path to the filename if found in any view paths. Otherwise null.
 **/
views.get = function getViewPath( file ){
  var res = null;
  views.paths.forEach( function(p){
    var absPath = path.join( p, file )
    if( fs.existsSync(absPath) )   
      return res = absPath;
    absPath = absPath+'.jade';
    if( fs.existsSync(absPath) )   
      return res = absPath;
    if( fs.existsSync(absPath) )   
      return res = absPath;
  });
  if( res )
    logger.info('router','delivering view: ' + res);
  return res;                      
}                                  
                                   
module.exports = views;            
