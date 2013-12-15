var chai = require('chai')
  , expect = chai.expect
  , helper = require('./helper')
  , nginuous = helper.nginuous
  , Gear = nginuous.Gear
  , modelRegistry = require('../lib/nginuous/db/model_registry');


var myGear = new Gear({});

describe( 'Gear', function(){

  it('creates a new gear', function(){
    expect( myGear ).to.be.instanceOf( Gear );
  })

  describe( 'after app initializiation', function(){

    before( function(){
      this.app = nginuous();
    });

    it('has a gear.test gear defined', function(){
      expect( this.app.gears ).to.have.property('test');
    });

    it("has loaded the gear's app directory", function(){
      expect( modelRegistry.modelPaths ).to.contain( __dirname+'/app/models' );
    });

  });

});

