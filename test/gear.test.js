var chai = require('chai')
  , expect = chai.expect
  , helper = require('./helper')
  , caminio = helper.caminio
  , Gear = caminio.Gear
  , modelRegistry = require('../lib/caminio/db/model_registry');


var myGear = new Gear({});

describe( 'Gear', function(){

  it('creates a new gear', function(){
    expect( myGear ).to.be.instanceOf( Gear );
  })

  describe( 'after app initializiation', function(){

    before( function(){
      this.app = caminio();
    });

    it('has a gear.test gear defined', function(){
      expect( this.app.gears ).to.have.property('test');
    });

    it("has loaded the gear's app directory", function(){
      expect( modelRegistry.modelPaths ).to.contain( __dirname+'/app/models' );
    });

  });

});

