var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , gearFactory = require('../../../lib/nginios/gear_factory')
  , i18nFactory = require('../../../lib/nginios/i18n_factory')
  , Controller = nginios.Controller;

var DashboardController = Controller.define( function( app ){

  var ctrl = this;

  this.get('/',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.nginios.render('index');
    });

  this.get('/apps/list',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.json(gearFactory.getApplicationsForUser(nginios.app.gears, res.locals.currentUser, res.locals.currentDomain, req.i18n ));
    });

  this.get('/translations/:lang.json',
    function( req, res ){
      var locale = i18nFactory.getTranslations();
      if( req.param('lang') in locale )
        return res.json(locale[req.param('lang')]['nginios']);
      res.json({});
    });

});

module.exports = DashboardController;
