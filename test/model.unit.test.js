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
  , expect = helper.chai.expect
  , Waterline = require('waterline');


describe('model', function(){

  before( function(done){
    helper.initApp( this, function(){ caminio = helper.caminio; done() });
  })
  
  describe('TestModel', function(){

    it('read from support/app/api/models/test_model.js', function(){
      expect(caminio.models).to.have.property('TestModel');
    });

    it('instance of Waterline Model', function(){
      expect(caminio.models.TestModel).to.have.property('create');
      expect(caminio.models.TestModel).to.have.property('find');
      expect(caminio.models.TestModel).to.have.property('findOne');
    });

  });

  describe('namespaced MyNamespace (my/namespace)', function(){

    it('read from support/app/api/models/my/namespace.js', function(){
      expect(caminio.models).to.have.property('MyNamespace');
    });

    it('instance of Waterline Model', function(){
      expect(caminio.models.TestModel).to.have.property('create');
    });

  });

});