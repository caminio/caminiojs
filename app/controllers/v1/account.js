var nginuous = require('../../../')
  , Controller = nginuous.Controller;

var AuthController = Controller.define( function( app ){

  this.before( nginuous.gears.nginuous.auth.authenticate );

  this.get('/accaunt', function( req, res ){
    if( req.body.email && req.body.password )
      tryAuthentication( req, res, saveAndRenderAuthToken );
    else
      nginuous.app.gears.nginuous.auth.fail(res, 401);
  });

});

module.exports = AuthController;

