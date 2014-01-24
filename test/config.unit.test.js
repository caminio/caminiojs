/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var helper = require('./helper')
  , fixtures = helper.fixtures
  , caminio
  , expect = helper.chai.expect;


describe('config', function(){

  before( function(done){
    helper.initApp( this, function(){ caminio = helper.caminio; done() });
  })
  
  it('routes.js', function(){
    expect(caminio.config.routes).to.be.an('object');
    expect(caminio.config.routes).to.have.property('/');
  });

  it('token.js', function(){
    expect(caminio.config.token).to.be.an('object');
    expect(caminio.config.token).to.have.property('timeout');
  });

  it('environemnts/<env>.js', function(){
    expect(caminio.config.port).to.be.a('number');
  });

  it('session.js', function(){
    expect(caminio.config.session).to.be.an('object');
    expect(caminio.config.session).to.have.property('timeout');
    expect(caminio.config.session).to.have.property('secret');
  });

});