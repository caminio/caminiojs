var caminio = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = caminio.Controller;

var UsersController = Controller.define( function( app ){

  this.requireAdmin = function requireAdmin( req, res, next ){
    if( !res.locals.currentUser.isAdmin( res.locals.currentDomain ) )
      return res.caminio.render('/errors/404');
    next();
  }


  // actions
  this.get('/',
           login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
           this.requireAdmin,
           function( req, res ){
             res.caminio.render('index');
           });

});



module.exports = UsersController;
