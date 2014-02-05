/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var superagent = require('superagent');

var helper = require('./helper');
var fixtures = helper.fixtures;
var caminio;
var autorest;
var expect = helper.chai.expect;

describe('Autorest find functions', function(){

  before( function(done){
    helper.initApp( this, function(){ 
      caminio = helper.caminio; 
      autorest = require( process.cwd()+'/lib/controller/autorest' )( caminio );
      done();
    });
  }); 

  describe('autorest route must match a modelName', function(){

    it('fails', function(){
      expect( function(){
        autorest.create( 'NonExistentModel', '/non_existent' );
      }).to.throw(/Missing model/);
    });

  });
  
  describe('create restful routes for ButterController', function(){

    before( function( done ){
      var test = this;
      fixtures['My::Butter'].create(function( err, butter ){
        test.butter = butter;
        done();
      });
    });

    it('find', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        done();
      });
    });

  });


});