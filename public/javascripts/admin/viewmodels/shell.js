define( function( require ){
  var router = require('plugins/router')
    , app = require('durandal/app')
    , i18n = require('i18next');

  return {
    router: router,
    search: function() {
      //It's really easy to show a message box.
      //You can add custom options too. Also, it returns a promise for the user's response.
      app.showMessage('Search not yet implemented...');
    },
    activate: function () {
      router.map([
        //{ route: '', title: i18n.t('navbar.overview'), moduleId: 'viewmodels/overview', nav: true },
        { route: '', title: i18n.t('navbar.users_groups'), moduleId: 'viewmodels/users', nav: true },
        { route: 'users', title: i18n.t('navbar.users_groups'), moduleId: 'viewmodels/users', nav: false },
        { route: 'domains', title: i18n.t('navbar.domains'), moduleId: 'viewmodels/domains', nav: (currentUser.superuser ? true : false) },
        { route: 'domains/:id', title: i18n.t('navbar.domains'), moduleId: 'viewmodels/domain', nav: false },
        { route: 'users/:id', moduleId: 'viewmodels/user', nav: false }
      ]).buildNavigationModel();

      return router.activate();
    }
  };

});
