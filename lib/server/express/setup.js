/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var express         = require('express');

module.exports = function ServerSetup( caminio, app ){

  app.use( express.cookieParser(caminio.config.session.secret) );
  
  app.use( express.json() );
  app.use( express.urlencoded() );

  //app.use( i18n.handle );
  //i18n.registerAppHelper(this.app.express);

  require('./session')( caminio, app );
  require('./flash')( caminio, app );

  // use jsonp callbacks
  app.set("jsonp callback", true);
  
}