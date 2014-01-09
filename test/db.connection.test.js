/**
 * testing database connection handler
 */

var chai = require('chai');
var expect = chai.expect;
var mongoose = require('mongoose');

var helper = require('./helper');
var caminio = helper.caminio;
var Application = require('../lib/caminio/application');

describe( 'MongoDB connectivity', function(){

  before( function(){
    this.app = caminio();
  });

  it( 'application has the mongoose.connection object in db object', function(){
    expect( this.app.db ).to.have.property( 'connection' );
    expect( this.app.db.connection ).to.eq( mongoose.connection );
  });

  it('does not create a new connection if already initialized, but shares mongoose connection', function(){
    var app = caminio();
    expect(this.app.db.connection).to.eq( app.db.connection );
  });

});

