/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var join        = require('path').join
  , inflection  = require('inflection');

module.exports = function GlobalExpressActions( caminio ){

  return [
    logControllerAction,
    injectCaminioRender
  ];

  function logControllerAction( req, res, next ){
    caminio.logger.info( 'serving ', req.method, req.routeName, ' with ', req.controllerName+'#'+req.actionName );
    next();
  }

  function injectCaminioRender( req, res, next ){
    res.caminio = {};
    // render by looking up the view paths
    // in all registered view directories
    res.caminio.render = function renderView( filename, options ){
      options = options || {};
      filename = filename || join( inflection.underscore(req.controllerName).replace('_controller',''), req.actionName );
      var absPath = caminio.views.lookup( filename );
      res.render( absPath, options );
    }
    next();
  }

}
