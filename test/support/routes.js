var helper = require('../helper')
  , caminio = helper.caminio;

caminio.router.add( 'v1/auth' );
caminio.router.add( 'v1/domains' );
caminio.router.add( 'v1/users' );
caminio.router.add( 'v1/accounts' );
caminio.router.add( 'v1/dashboard' );
