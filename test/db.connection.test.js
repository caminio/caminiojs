/**
 * testing database connection handler
 */

var chai = require('chai');
var expect = chai.expect;
var mongoose = require('mongoose');

var helper = require('./helper');
var nginious = helper.nginious;
var Application = require('../lib/nginious/application');

describe( 'MongoDB connectivity', function(){

  before( function(){
    this.app = nginious();
  });

  it( 'application has the mongoose.connection object in db object', function(){
    expect( this.app.db ).to.have.property( 'connection' );
    expect( this.app.db.connection ).to.eq( mongoose.connection );
  });

  it('does not create a new connection if already initialized, but shares mongoose connection', function(){
    var app = nginious();
    expect(this.app.db.connection).to.eq( app.db.connection );
  });

});

