var caminio = require('caminio');

caminio.router.add('/','main');
caminio.router.add('v1/auth');
caminio.router.add('v1/admin');
caminio.router.add('v1/users');
caminio.router.add('v1/domains');
caminio.router.add('shop/v1/shop_items');
caminio.router.add('v1/dashboard');

