var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var UsersController = Controller.define( function( app ){

  this.changeDomainIfReq = function changeDomainIfReq( req, res, next ){
    if( req.param('change_domain_id') )
      nginios.orm.models.Domain.findOne({ _id: req.param('change_domain_id') }, function( err, domain ){
        if( err )
          console.log('error', err);
        if( domain )
          res.locals.currentDomain = req.session.domain = domain;
        return next( err );
      });
    else
      next();
  }

  this.requireAdmin = function requireAdmin( req, res, next ){
    if( !res.locals.currentUser.isAdmin( res.locals.currentDomain ) )
      return res.nginios.render('/errors/404');
    next();
  }


  // actions
  this.get('/',
           login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
           this.changeDomainIfReq,
           this.requireAdmin,
           function( req, res ){
             res.nginios.render('index');
           });

});



module.exports = UsersController;
