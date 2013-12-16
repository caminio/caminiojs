/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

// User fixture

var fixture = {};

fixture.plain = {
  name: {
    first: 'Henry',
    last: 'King'
  },
  email: 'henry.king'+(new Date().getTime().toString())+'@localhost.local',
  password: 'test123?T',
  description: '',
  phone: '013920369236'
};

module.exports = fixture
