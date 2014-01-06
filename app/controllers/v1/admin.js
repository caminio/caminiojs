var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var UsersController = Controller.define( function( app ){

  // actions
  this.get('/',
           login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
           function( req, res ){
             res.nginios.render('index');
           });

});



module.exports = UsersController;
