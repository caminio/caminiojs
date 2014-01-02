var nginios = require('../../../')
  , Controller = nginios.Controller;

var MainController = Controller.define( function( app ){

  this.get('/',
    function( req, res ){
      res.nginios.render('index');
    });

});

module.exports = MainController;
