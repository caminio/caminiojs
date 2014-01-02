var helper = require('../helper')
  , nginios = helper.nginios;

nginios.router.add( 'v1/auth' );
nginios.router.add( 'v1/domains' );
nginios.router.add( 'v1/accounts' );
nginios.router.add( 'v1/dashboard' );
