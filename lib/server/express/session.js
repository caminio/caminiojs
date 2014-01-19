/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var express       = require('express');

/**
 * the default session store
 *
 * if config/session.js has a `store` object
 * it will be used for handling sessions
 *
 * @class config
 * @property session
 */
module.exports = function( caminio, app ){

  if( caminio.config.session.store )
    app.use( express.session({
      secret: caminio.config.session.secret,
      store: caminio.config.session.store
    }));
  else
    app.use(express.session({
      secret: caminio.config.session.secret
    }));

}