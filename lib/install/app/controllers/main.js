var caminio = require('caminio')
  , Controller = caminio.Controller;

var MainController = Controller.define( function( app ){

  this.get('/',
    function( req, res ){
      res.caminio.render('index');
    });

});

module.exports = MainController;
