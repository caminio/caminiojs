var passport = require('passport')
  , LocalStrategy = require('passport-local').Strategy
  , ConsumerStrategy = require('passport-http-oauth').ConsumerStrategy
  , TokenStrategy = require('passport-http-oauth').TokenStrategy;

  module.exports = function(){
    
    var nginious = require('../../')

    /**
     * LocalStrategy
     *
     * This strategy is used to authenticate users based on a username and password.
     * Anytime a request is made to authorize an application, we must ensure that
     * a user is logged in before asking them to approve the request.
     */
    passport.use('local', new LocalStrategy(
      function(username, password, done) {
        nginious.orm.models.User.findOne({ email: username }, function( err, user ){
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
      nginious.orm.models.User.findOne({ _id: id }, function(err, user ){
        done( err, user );
      });
    });


    /**
     * ConsumerStrategy
     *
     * This strategy is used to authenticate registered OAuth consumers (aka
     * clients). It is employed to protect the `request_tokens` and `access_token`
     * endpoints, which consumers use to request temporary request tokens and access
     * tokens.
     */
    passport.use('consumer', new ConsumerStrategy(
          // consumer callback
          //
          // This callback finds the registered client associated with `consumerKey`.
          // The client should be supplied to the `done` callback as the second
          // argument, and the consumer secret known by the server should be supplied
          // as the third argument. The `ConsumerStrategy` will use this secret to
          // validate the request signature, failing authentication if it does not
          // match.
          function(consumerKey, done) {
            nginious.orm.models.Client.findOne({ token: consumerKey }, function( err, client ){
              if (err) { return done(err); }
              if (!client) { return done(null, false); }
              return done(null, client, client.secret);
            });
          },
          // token callback
          //
          // This callback finds the request token identified by `requestToken`. This
          // is typically only invoked when a client is exchanging a request token for
          // an access token. The `done` callback accepts the corresponding token
          // secret as the second argument. The `ConsumerStrategy` will use this secret to
          // validate the request signature, failing authentication if it does not
          // match.
          //
          // Furthermore, additional arbitrary `info` can be passed as the third
          // argument to the callback. A request token will often have associated
          // details such as the user who approved it, scope of access, etc. These
          // details can be retrieved from the database during this step. They will
          // then be made available by Passport at `req.authInfo` and carried through to
          // other middleware and request handlers, avoiding the need to do additional
          // unnecessary queries to the database.
      function(token, done) {
        console.log('token', token);
        var info;
        if( token )
          info = { verifier: token.verifier,
            clientID: token.client,
            userID: token.user,
            approved: true //(token.approved && token.approved.at instanceof Date ? true : false)
          };
        done(null, token.secret, info);
      },
      // validate callback
      //
      // The application can check timestamps and nonces, as a precaution against
      // replay attacks. In this example, no checking is done and everything is
      // accepted.
      function(timestamp, nonce, done) {
        // TODO: implement timestamp checks
        done(null, true);
      }
    ));

    /**
     * TokenStrategy
     *
     * This strategy is used to authenticate users based on an access token. The
     * user must have previously authorized a client application, which is issued an
     * access token to make requests on behalf of the authorizing user.
     */
    passport.use('token', new TokenStrategy(
          // consumer callback
          //
          // This callback finds the registered client associated with `consumerKey`.
          // The client should be supplied to the `done` callback as the second
          // argument, and the consumer secret known by the server should be supplied
          // as the third argument. The `TokenStrategy` will use this secret to
          // validate the request signature, failing authentication if it does not
          // match.
          function(consumerKey, done) {
            console.log('getting client');
            nginious.orm.models.Client.findOne({ token: consumerKey }, function(err, client) {
              if (err) { return done(err); }
              if (!client) { return done(null, false); }
              return done(null, client, client.secret);
            });
          },
          // verify callback
          //
          // This callback finds the user associated with `accessToken`. The user
          // should be supplied to the `done` callback as the second argument, and the
          // token secret known by the server should be supplied as the third argument.
          // The `TokenStrategy` will use this secret to validate the request signature,
          // failing authentication if it does not match.
          //
          // Furthermore, additional arbitrary `info` can be passed as the fourth
          // argument to the callback. An access token will often have associated
          // details such as scope of access, expiration date, etc. These details can
          // be retrieved from the database during this step. They will then be made
          // available by Passport at `req.authInfo` and carried through to other
          // middleware and request handlers, avoiding the need to do additional
          // unnecessary queries to the database.
          //
          // Note that additional access control (such as scope of access), is an
          // authorization step that is distinct and separate from authentication.
          // It is an application's responsibility to enforce access control as
          // necessary.
      function(accessToken, done) {
        console.log('getting access token');
        nginious.orm.models.AccessToken.findOne({ token: accessToken }).populate('client').populate('user').exec( function(err, token) {
          if (err) { return done(err); }
          if (!token.user) { return done(null, false); }
          if( !token.client){ return done(null,false); }
          var info = { scope: token.client.scope }
          done(null, user, token.secret, info);
        });
      },
      // validate callback
      //
      // The application can check timestamps and nonces, as a precaution against
      // replay attacks. In this example, no checking is done and everything is
      // accepted.
      function(timestamp, nonce, done) {
        console.log('validate');
        done(null, true)
      }
    ));

  }
