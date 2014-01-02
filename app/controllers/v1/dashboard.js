var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var DashboardController = Controller.define( function( app ){

  this.get('/',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.nginios.render('index');
    });

});

module.exports = DashboardController;
