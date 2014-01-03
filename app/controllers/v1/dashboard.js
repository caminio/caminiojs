var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var DashboardController = Controller.define( function( app ){

  this.get('/',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.nginios.render('index');
    });

  this.get('/gears/list',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      gears = [];
      for( var gearName in nginios.app.gears ){
        var gear = nginios.app.gears[gearName];
        console.log( res.locals.currentUser );
        if( res.locals.currentDomain.allowed_gears.indexOf(gear.name) )
          gears.push( gear );
      }
      res.json(gears);
    });

});

module.exports = DashboardController;
