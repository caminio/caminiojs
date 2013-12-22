var nginuous = require('../../../')
  , Controller = nginuous.Controller;

var AuthController = Controller.define( function( app ){

  this.before( nginuous.gears.nginuous.auth.authenticate );

  this.get('/account',
    login.ensureLoggedIn(),
    function(req, res) {
      res.json( req.user );
      //res.render('/views/account', { user: req.user });
    });

});

module.exports = AuthController;

