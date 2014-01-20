/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var express       = require('express')
  , passport      = require('passport');

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

  caminio.express.use( passport.initialize() );
  caminio.express.use( passport.session() );


  passport.serializeUser(function(user, done) {
    done(null, user.id);
  });

  passport.deserializeUser(function(id, done) {
    caminio.models.User.findOne({ _id: id }).exec( function(err, user ){
      if( err ){ return done( err ); }
      if( user ){
        if( !user.last_request_at || user.last_request_at.getTime() < (new Date()) - ( caminio.config.session.timeout ) )
          return done( null, null );
        user.update({ last_request_at: new Date() }, function( err ){
          done( err, user );
        })
      } else {
        done( err, user );
      }
    });
  });

}