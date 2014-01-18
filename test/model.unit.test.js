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


describe('model', function(){

  before( function(done){
    helper.initApp( this, function(){ caminio = helper.caminio; done() });
  })
  
  describe('TestModel', function(){

    it('read from support/app/api/models/test_model.js', function(){
      expect(caminio.models).to.have.property('TestModel');
    });

    it('instance of Mongoose Model', function(){
      expect(caminio.models.TestModel).to.have.property('create');
      expect(caminio.models.TestModel).to.have.property('find');
      expect(caminio.models.TestModel).to.have.property('findOne');
    });

    it('builds a new instance of model', function(){
      var testModel = new caminio.models.TestModel({ name: 'test' });
      expect(testModel).to.have.property('name');
    })

  });

  describe('namespaced My::Namespace (my/namespace)', function(){

    it('read from support/app/api/models/my/namespace.js', function(){
      expect(caminio.models).to.have.property('My::Namespace');
    });

    it('instance of Mongoose Model', function(){
      expect(caminio.models.TestModel).to.have.property('create');
    });

  });

});