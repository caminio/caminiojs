var nginios = require('../../../')
  , Controller = nginios.Controller;

var DomainsController = Controller.define( function( app ){

  this.before( app.gears.nginios.auth.authenticate );

  this.get('/', function( req, res ){
    res.json(null);
  });

});

module.exports = DomainsController;

