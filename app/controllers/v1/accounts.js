var passport = require('passport')
  , nginuous = require('../../../')
  , Controller = nginuous.Controller;

var AccountsController = Controller.define( function( app ){

  this.get('/me',
    passport.authenticate('token', { session: false }),
    function(req, res) {
      res.json( {name:'test'} );
    });

});

module.exports = AccountsController;

