/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fixtures = require('nginuous-fixtures');

fixtures.define('user', {
  name: {
    first: 'Henry',
    last: 'King'
  },
  email: function(){
    return 'henry.king'+(Math.random(1000)*(new Date().getTime()).toString())+'@localhost.local';
  },
  password: 'test123?T',
  description: '',
  phone: '013920369236'
});
