var helper = require('../helper')
  , nginious = helper.nginious;

nginious.router.add( 'v1/auth' );
nginious.router.add( 'v1/domains' );
nginious.router.add( 'v1/accounts' );
