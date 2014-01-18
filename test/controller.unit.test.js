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
  , request = require('superagent')
  , expect = helper.chai.expect;


describe('controller', function(){

  before( function(done){
    helper.initApp( this, function(){ caminio = helper.caminio; done() });
  })
  
  describe('MainController', function(){

    it('read from support/app/api/controllers/main_controller.js', function(){
      expect( caminio.controller.routes() ).to.include('/ GET MainController');
    });

  });

  describe('a namespaced controller', function(){

    it('read from support/app/api/controllers/my/namespaced_controller.js', function(){
      expect( caminio.controller.routes() ).to.include('/namespaced GET My::NamespacedController');
    });

  });

  describe('middleware from policies', function(){

    it('includes policies if defined in controller', function(done){
      request.get(helper.url+'/')
      .end( function( err, res ){
        expect(res.text).to.include('testAuthenticated');
        done();
      });
    });

  });

  describe('middleware from middleware', function(){

    it('includes middleware if defined in controller', function(done){
      request.get(helper.url+'/middleware')
      .end( function( err, res ){
        expect(res.text).to.include('middlewareincluded');
        done();
      });
    });

  });

  describe('_before array', function(){

    it('includes both middleware modules', function(done){
      request.get(helper.url+'/middleware')
      .end( function( err, res ){
        expect(res.text).to.include('specialincluded');
        expect(res.text).to.include('againspecincluded');
        done();
      });
    });

  });
});