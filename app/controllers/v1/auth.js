var caminio = require('../../../')
  , passport = require('passport')
  , login = require('connect-ensure-login')
  , moment = require('moment')
  , utils = caminio.utils
  , Controller = caminio.Controller;

function fail( res, options ){
  caminio.app.gears.caminio.auth.fail( res, options );
}

var AuthController = Controller.define( function( app, namespacePrefix ){

  this.post('/login',
    function( req, res, next ){
      req.session.domain = null;
      next();
    },
    passport.authenticate('local', { successReturnToOrRedirect: this.resolvePath('v1/dashboard'), 
      failureRedirect: namespacePrefix+'/login',
      failureFlash: true }) 
    );

  this.get('/',
    function( req, res){
      res.caminio.render( 'login' );
    });

  this.get('/login', 
    function( req, res ){ 
      res.caminio.render( 'login' );
    });

  this.get('/logout', 
    function(req, res) {
      req.logout();
      req.session.current_domain_id = null;
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
      //login.ensureLoggedIn( this.resolvePath(null,'/login')),
      login.ensureLoggedIn(namespacePrefix+'/login'),
      function( req, res ){
        caminio.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
          if (err) { return fail( res, { status: 401, description: err }); }
          if( !token ) { return fail( res, { status: 401, description: 'unauthorized_client' }) }
          res.render('authorize');
        });
      })

  this.post('/dialog/authorize/decision',
      login.ensureLoggedIn(namespacePrefix+'/login'),
      function( req, res ){
        caminio.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
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
      app.gears.caminio.auth.maintainRequestTokens,
      app.gears.caminio.auth.loadClient,
      function(req,res){
        var token = utils.uid(8);
        var secret = utils.uid(32);
        // TODO: prevent reply attacks by looking up if that ip address
        // has any request tokens already
        var requestToken = new caminio.orm.models.RequestToken({ 
          client: req.param('client_id'), 
            redirect_uri: req.param('redirect_uri'),
            scope: req.param('scope'),
            ip_address: caminio.app.gears.caminio.auth.ipAddress( req ),
            token: token, 
            secret: secret });
        requestToken.tries.push({ 
          ip_address: caminio.app.gears.caminio.auth.ipAddress(req),
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
      app.gears.caminio.auth.maintainAccessTokens,
      app.gears.caminio.auth.loadClient,
      app.gears.caminio.auth.loadRequestToken,
      function(req,res){
        var token = utils.uid(8);
        var secret = utils.uid(32);
        // TODO: prevent reply attacks by looking up if that ip address
        // has any request tokens already
        var accessToken = new caminio.orm.models.AccessToken({ 
          client: req.param('client_id'), 
          user: res.locals.client.user,
          request_uri: req.param('request_uri'),
          scope: req.param('scope'),
          ip_address: caminio.app.gears.caminio.auth.ipAddress( req ),
          refresh_token: utils.uid(8),
          expires_in: moment().add('h',2).toDate(),
          token: token, 
          secret: secret });
        accessToken.save( function( err ){
            if( err ){ return fail( res, { status: 500, description: err })}
            if( !accessToken ){ return fail( res, { status: 500, description: 'server_error' }); }
            res.json( accessToken.toToken() ); 
          });
      });

  this.get('/test',
      app.gears.caminio.auth.token,
      function(req,res){
        res.json( res.locals.user );
      });

});

module.exports = AuthController;

