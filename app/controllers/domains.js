var nginuous = require('../../')
  , Controller = nginuous.Controller;

var DomainsController = Controller.define( function(){

  this.get('/', function( req, res ){
    res.json(null);
  });

});

module.exports = DomainsController;

