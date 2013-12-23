var nginious = require('../../../')
  , Controller = nginious.Controller;

var DomainsController = Controller.define( function( app ){

  this.before( app.gears.nginious.auth.authenticate );

  this.get('/', function( req, res ){
    res.json(null);
  });

});

module.exports = DomainsController;

