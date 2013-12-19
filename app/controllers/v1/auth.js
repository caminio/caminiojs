var nginuous = require('../../../')
  , Controller = nginuous.Controller;

/**
 * try auhentication
 *
 * if email and password match,
 * an api token is created
 *
 * but only, if the auth_token.at is older than
 * configured auth_token_timeout set in nginuous.config.auth_token_timeout
 */
function tryAuthentication( req, res, next ){
  nginuous.orm.models.User.findOne({ email: req.body.email }, function( err, user ){
    if( !user )
      return nginuous.app.gears.nginuous.auth.fail(401);
    if( !user.authenticate( req.body.password ) )
      return nginuous.app.gears.nginuous.auth.fail(401);

    next( user, req, res );
  });
}

/**
 * checks, if auth_token is free (not occupied by anybody else)
 * generates a new one and renders auth_token
 *
 * as json response
 *
 * @api private
 */
function saveAndRenderAuthToken( user, req, res ){
  if( user.auth_token_at && user.auth_token.at > ((new Date())-(nginuous.config.auth_token_timeout_min*60*1000)) ){
    var lastTokenAgeMin = parseInt( (new Date() - user.auth_token.at) / 1000 / 60 )
    return nginuous.app.gears.nginuous.auth.fail(res, 423, 'The requested account is locked for ' + lastTokenAgeMin + ' minutes' );
  }
  var ipAddress = req.headers['x-forwarded-for'] || req.connection.remoteAddress
  user.regenerateAuthToken( ipAddress );
  user.save( function( err ){
    if( err )
      return nginuous.app.gears.nginuous.auth.fail(res, 500, err);
    res.json({ auth_token: user.auth_token.token });
  });
}

var AuthController = Controller.define( function( app ){

  this.post('/', function( req, res ){
    if( req.body.email && req.body.password )
      tryAuthentication( req, res, saveAndRenderAuthToken );
    else
      nginuous.app.gears.nginuous.auth.fail(res, 401);
  });

});

module.exports = AuthController;

