var nginious = require('../../../')
  , passport = require('passport')
  , login = require('connect-ensure-login')
  , utils = nginious.utils
  , Controller = nginious.Controller;

function fail( res, options ){
  nginious.app.gears.nginious.auth.fail( res, options );
}

var AuthController = Controller.define( function( app, namespacePrefix ){

  this.post('/login',
    passport.authenticate('local', { successReturnToOrRedirect: '/', failureRedirect: namespacePrefix+'/login' }) );

  this.get('/login', 
    function( res, res ){ 
      res.render('login') 
    });

  this.get('/logout', 
    function(req, res) {
      req.logout();
      res.redirect('/');
    });

  this.get('/provider',
    function( req, res ){
      res.json({error: 'not_implemented'});
    });

  this.get('/provider/callback',
    function( req, res ){
      res.json({error: 'not_implemented'});
    });

  this.get('/dialog/authorize',
      login.ensureLoggedIn(namespacePrefix+'/login'),
      function( req, res ){
        nginious.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
          if (err) { return fail( res, { status: 401, description: err }); }
          if( !token ) { return fail( res, { status: 401, description: 'unauthorized_client' }) }
          res.render('authorize');
        });
      })

  this.post('/dialog/authorize/decision',
      login.ensureLoggedIn(namespacePrefix+'/login'),
      function( req, res ){
        nginious.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
          if (err) { return fail( res, { status: 401, description: err }); }
          if( !token ) { return fail( res, { status: 401, description: 'unauthorized_client' }) }
          token.approved.at = new Date();
          token.save( function( err ){
            if (err) { return fail( res, { status: 500, description: err }); }
            res.redirect(token.redirect_uri);
          });
        });
      });

  this.post('/oauth/request_token',
      app.gears.nginious.auth.maintainRequestTokens,
      app.gears.nginious.auth.loadClient,
      function(req,res){
        var token = utils.uid(8);
        var secret = utils.uid(32);
        // TODO: prevent reply attacks by looking up if that ip address
        // has any request tokens already
        var requestToken = new nginious.orm.models.RequestToken({ 
          client: req.param('client_id'), 
            redirect_uri: req.param('redirect_uri'),
            scope: req.param('scope'),
            ip_address: nginious.app.gears.nginious.auth.ipAddress( req ),
            token: token, 
            secret: secret });
        requestToken.tries.push({ 
          ip_address: nginious.app.gears.nginious.auth.ipAddress(req),
          at: new Date(),
          tries: 1
        });
        requestToken.save( function( err ){
            if( err ){ return fail( res, { status: 500, description: err })}
            if( !requestToken ){ return fail( res, { status: 500, description: 'server_error' }); }
            res.json( { code: requestToken.token } );
          });
      });

  this.post('/oauth/access_token',
      app.gears.nginious.auth.maintainAccessTokens,
      app.gears.nginious.auth.loadClient,
      app.gears.nginious.auth.loadRequestToken,
      function(req,res){
        var token = utils.uid(8);
        var secret = utils.uid(32);
        // TODO: prevent reply attacks by looking up if that ip address
        // has any request tokens already
        var accessToken = new nginious.orm.models.AccessToken({ 
          client: req.param('client_id'), 
          user: res.locals.client.user,
          request_uri: req.param('request_uri'),
          scope: req.param('scope'),
          ip_address: nginious.app.gears.nginious.auth.ipAddress( req ),
          token: token, 
          secret: secret });
        accessToken.save( function( err ){
            if( err ){ return fail( res, { status: 500, description: err })}
            if( !accessToken ){ return fail( res, { status: 500, description: 'server_error' }); }
            res.json( { token_type: 'bearer', access_token: accessToken.token } );
          });
      });

  this.get('/test',
      app.gears.nginious.auth.token,
      function(req,res){
        res.json( res.locals.user );
      });

});

module.exports = AuthController;

