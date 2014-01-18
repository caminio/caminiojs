/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var fs            = require('fs')
  , path          = require('path')
  , _             = require('lodash');

module.exports = function initConfig( caminio ){

  caminio.config = caminio.config || {};

  /**
   * inject caminio defaults
   */
  _.merge( caminio.config, require('./defaults')(caminio) );


  /**
   * read in user config
   */
  _.merge( caminio.config, require('./user_config')(caminio) );

}