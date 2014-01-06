define(['plugins/router', 'durandal/app', 'i18next'], function (router, app, i18n) {
    return {
        router: router,
        search: function() {
            //It's really easy to show a message box.
            //You can add custom options too. Also, it returns a promise for the user's response.
            app.showMessage('Search not yet implemented...');
        },
        activate: function () {
            router.map([
                { route: '', title: i18n.t('navbar.overview'), moduleId: 'viewmodels/overview', nav: true },
                { route: 'billing', title: i18n.t('navbar.billing'), moduleId: 'viewmodels/billing', nav: true },
                { route: 'users', title: i18n.t('navbar.users_groups'), moduleId: 'viewmodels/users', nav: true }
            ]).buildNavigationModel();
            
            return router.activate();
        }
    };
});
