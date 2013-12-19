var nginuous = require('../../../')
  , Controller = nginuous.Controller;

var DomainsController = Controller.define( function( app ){

  this.before( app.gears.nginuous.auth.authenticate );

  this.get('/', function( req, res ){
    res.json(null);
  });

});

module.exports = DomainsController;

