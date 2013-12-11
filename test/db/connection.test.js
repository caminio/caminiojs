/**
 * testing database connection handler
 */

var chai = require('chai');
var expect = chai.expect;

var helper = require('../helper');
var nginuous = helper.nginuous;
var Application = require('../../lib/nginuous/application');

describe( 'SQLite db', function(){

  it( 'open a new connection to test/db.sqlite3', function(){
    var app = nginuous();
    expect( app ).to.be.instanceOf( Application );
  });

});

