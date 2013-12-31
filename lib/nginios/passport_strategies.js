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
        nginios.orm.models.User.findOne({ email: username }, function( err, user ){
          if( err || !user )
            return done(err || 'not_found');
          if( !user.authenticate( password ) )
            return done('invalid_password');
          done( null, user );
        });
      }
    ));

    passport.serializeUser(function(user, done) {
      done(null, user.id);
    });

    passport.deserializeUser(function(id, done) {
      nginios.orm.models.User.findOne({ _id: id }, function(err, user ){
        done( err, user );
      });
    });


  }
