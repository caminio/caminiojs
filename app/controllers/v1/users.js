var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , moment = require('moment')
  , Controller = nginios.Controller;

var UsersController = Controller.define( function( app ){

  var ctrl = this;

  this.get('/',
    login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
    function( req, res ){
      res.json([]);
    });

});

module.exports = UsersController;
