var passport = require('passport')
  , nginious = require('../../../')
  , Controller = nginious.Controller;

var AccountsController = Controller.define( function( app ){

  this.get('/me',
    passport.authenticate('token', { session: false }),
    function(req, res) {
      res.json( {name:'test'} );
    });

});

module.exports = AccountsController;

