/**
 * testing application
 */

var chai = require('chai');
var expect = chai.expect;

var helper = require('./helper');
var nginios = helper.nginios;
var Application = require('../lib/nginios/application');

describe( 'Application', function(){

  before( function(){
    this.app = nginios();
  });

  it('app is an instance of Application', function(){
    expect( this.app ).to.be.instanceOf( Application );
  });

  it('app has a config object', function(){
    expect( this.app ).to.have.property( 'config' );
  });

  it('app has original express application object as express', function(){
    expect( this.app ).to.have.property( 'express' );
  });

});

