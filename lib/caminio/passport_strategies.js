var passport = require('passport')
  , logger = require('./logger')
  , LocalStrategy = require('passport-local').Strategy

  module.exports = function(){
    
    var caminio = require('../../')

    /**
     * LocalStrategy
     *
     * This strategy is used to authenticate users based on a username and password.
     * Anytime a request is made to authorize an application, we must ensure that
     * a user is logged in before asking them to approve the request.
     */
    passport.use('local', new LocalStrategy(
      function(username, password, done) {
        caminio.orm.models.User.findOne({ email: username }).exec( function( err, user ){
          if( err ){ logger.error('auth',err); return done(err); }
          if( !user ){ return done(null, false, { message: 'user_unknown' }); }
          if( !user.authenticate( password ) )
            return done( null, false, { message: 'authentication_failed' });
          user.update({ 'last_login.at': new Date(), last_request_at: new Date() }, function( err ){
            if( err ){ return done(err); }
            done( null, user );
          })
        });
      }
    ));

    passport.serializeUser(function(user, done) {
      done(null, user.id);
    });

    passport.deserializeUser(function(id, done) {
      caminio.orm.models.User.findOne({ _id: id }).exec( function(err, user ){
        if( err ){ return done( err ); }
        if( user ){
          if( !user.last_request_at || user.last_request_at.getTime() < (new Date()) - ( caminio.app.config.session_timeout_min * 60 * 1000 ) )
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
