var helper = require('../helper')
  , nginuous = helper.nginuous;

nginuous.router.add( 'v1/auth' );
nginuous.router.add( 'v1/domains' );
nginuous.router.add( 'v1/accounts' );
