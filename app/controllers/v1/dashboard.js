var caminio = require('../../../')
  , login = require('connect-ensure-login')
  , gearFactory = require('../../../lib/caminio/gear_factory')
  , i18nFactory = require('../../../lib/caminio/i18n_factory')
  , Controller = caminio.Controller;

var DashboardController = Controller.define( function( app ){

  var ctrl = this;

  this.get('/',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.caminio.render('index');
    });

  this.get('/apps/list',
    login.ensureLoggedIn( this.resolvePath('v1/auth','/login')),
    function( req, res ){
      res.json(gearFactory.getApplicationsForUser(caminio.app.gears, res.locals.currentUser, res.locals.currentDomain, req.i18n ));
    });

  this.get('/translations/:lang.json',
    function( req, res ){
      var locale = i18nFactory.getTranslations();
      if( req.param('lang') in locale )
        return res.json(locale[req.param('lang')]['caminio']);
      res.json({});
    });

});

module.exports = DashboardController;
