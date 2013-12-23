var nginuous = require('../../../')
  , passport = require('passport')
  , login = require('connect-ensure-login')
  , utils = nginuous.utils
  , Controller = nginuous.Controller;

function fail( res, status ){
  nginuous.gears.nginuous.auth.fail( res, status );
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
        app.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
          if (err) { return fail( 401, err ); }
          if( !token ) { return fail( 401, 'unauthorized_client') }
          res.render('authorize');
        });
      })

  this.post('/dialog/authorize/decision',
      login.ensureLoggedIn(namespacePrefix+'/login'),
      function( req, res ){
        app.orm.models.RequestToken.findOne({ token: req.param('request_token') }, function(err, token) {
          if (err) { return fail( 401, err ); }
          if( !token ) { return fail( 401, 'unauthorized_client') }
          token.approved.at = new Date();
          token.save( function( err ){
            if (err) { return fail( 500, err ); }
            res.redirect(token.redirect_uri);
          });
        });
      });

  this.post('/oauth/request_token', 
      function(req,res){
        var token = utils.uid(8);
        var secret = utils.uid(32);
        // TODO: prevent reply attacks by looking up if that ip address
        // has any request tokens already
        app.orm.models.RequestToken.create({ 
          client: req.param('client_id'), 
          callback_url: req.param('callback_url'),
          scope: req.param('scope'),
          ip_address: nginuous.app.gears.auth.ipAddress(),
          token: req.param('token'), 
          secret: secret }, function( err, requestToken ){
            if( err ){ return fail( 500, err )}
            if( requestToken ){ return fail( 500, 'server_error' ); }
            res.json( requestToken );
          });
      });

  this.post('/oauth/access_token',
      function(req,res){
        res.send('not_implemented');
      });

});

module.exports = AuthController;

