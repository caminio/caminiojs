/**
 * nginuous test helper
 */

var helper = {};

helper.nginuous = require('../');

helper.fixtures = require('nginuous-fixtures');
helper.fixtures.readFixtures();
// enable ORM (mongoose)
helper.fixtures.enableORM( helper.nginuous );

helper.chai = require('chai');
helper.chai.Assertion.includeStack = true;


module.exports = helper;
