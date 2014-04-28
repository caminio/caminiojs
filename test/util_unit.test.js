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
  , util = require('../lib/util')
  , expect = helper.chai.expect;


describe('util', function(){
  
  describe('normalize filename', function(){

    it('normalizes white spaces to underscores', function(){
      expect( util.normalizeFilename('test test') ).to.eql( 'test_test' );
    });

    it('leaves dots (.) in filename', function(){
      expect( util.normalizeFilename('test. test.jpg') ).to.eql( 'test._test.jpg' );
    });

    it('lowercases characters', function(){
      expect( util.normalizeFilename('tESt. teSt.jpg') ).to.eql( 'test._test.jpg' );
    });

    it('translates ä -> ae', function(){
      expect( util.normalizeFilename('test with ä As String.txt.js') ).to.eql( 'test_with_ae_as_string.txt.js' );
    });

    it('translates ü -> ue', function(){
      expect( util.normalizeFilename('test with ü As String.txt.js') ).to.eql( 'test_with_ue_as_string.txt.js' );
    });

    it('translates ö -> oe', function(){
      expect( util.normalizeFilename('test with ö As String.txt.js') ).to.eql( 'test_with_oe_as_string.txt.js' );
    });

    it('translates ß -> sz', function(){
      expect( util.normalizeFilename('test with ß As String.txt.js') ).to.eql( 'test_with_sz_as_string.txt.js' );
    });

  });

  describe('generates a unique id of characters', function(){

    it('generates uid of 8 characters', function(){
      expect( util.uid(8) ).to.match(/[\d\w]{8}/);
    });

    it('generates uid of 20 characters', function(){
      expect( util.uid(20) ).to.match(/[\d\w]{20}/);
    });

  });

});