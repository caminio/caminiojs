var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var DomainsController = Controller.define( function( app ){

  // private
  this.getDomains = function getDomains( req, res, next ){
    nginios.orm.models.Domain
    .find()
    .exec( function( err, domains ){
      req.domains = domains;
      next(err);
    });
  }

  // actions
  this.get('/',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getDomains,
          function( req, res ){
            res.json( { items: req.domains } );
          });

});

module.exports = DomainsController;

