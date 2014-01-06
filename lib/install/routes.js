var nginios = require('nginios');

nginios.router.add('/','main');
nginios.router.add('v1/auth');
nginios.router.add('v1/admin');
nginios.router.add('v1/users');
nginios.router.add('v1/domains');
nginios.router.add('shop/v1/shop_items');
nginios.router.add('v1/dashboard');

