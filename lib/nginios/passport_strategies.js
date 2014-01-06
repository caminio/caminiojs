var passport = require('passport')
  , LocalStrategy = require('passport-local').Strategy

  module.exports = function(){
    
    var nginios = require('../../')

    /**
     * LocalStrategy
     *
     * This strategy is used to authenticate users based on a username and password.
     * Anytime a request is made to authorize an application, we must ensure that
     * a user is logged in before asking them to approve the request.
     */
    passport.use('local', new LocalStrategy(
      function(username, password, done) {
        nginios.orm.models.User.findOne({ email: username }).populate('domains').exec( function( err, user ){
          if( err ){ return done(err); }
          if( !user ){ return done(null, false, { message: 'user_unknown' }); }
          if( !user.authenticate( password ) )
            return done( null, false, { message: 'authentication_failed' });
          user.update({ 'last_login.at': new Date() }, function( err ){
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
      nginios.orm.models.User.findOne({ _id: id }).populate('domains').exec( function(err, user ){
        done( err, user );
      });
    });


  }
