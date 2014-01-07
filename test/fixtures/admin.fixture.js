/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fixtures = require('nginios-fixtures');

fixtures.define('admin', 'User', {
  name: {
    first: 'Henry',
    last: 'King'
  },
  email: function(){
    return 'henry.king'+(Math.random(1000)*(new Date().getTime()).toString())+'@localhost.local';
  },
  role: 1,
  password: 'test123?T',
}).beforeCreate( function( err, admin, next ){
  fixtures.domain.create( function( err, domain ){
    domain.owner = admin;
    domain.save( function( err ){
      admin.domains.push( domain );
      admin.save( function( err ){
        next(err, admin);
      })
    })
  });
});
