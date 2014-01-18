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
  , path          = require('path');

module.exports = function( caminio ){

  /**
   * get current caminio pkg information
   */
  function pkgInfo(){
    var pkgFilename = path.join(__dirname,'..','..','package.json');
    var pkgFile = fs.readFileSync( pkgFilename );
    return JSON.parse( pkgFile );
  }

  var pkg = pkgInfo();

  var config = _.merge({
    root:           process.cwd(),
    version:        pkg.version
  }, caminio.config || {});

  config.paths = {

    config:       config.root+'/config',
  
    'public':     config.root+'/.tmp/public',

    views:        config.root+'/app/views',

    layout:       config.root+'/app/views/layouts',


  }

  config.log = _.merge({
    filename: config.root+'/log/'+caminio.env+'.log'
  }, caminio.config.log || {});

  return config;

}