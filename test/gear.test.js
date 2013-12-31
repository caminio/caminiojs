var chai = require('chai')
  , expect = chai.expect
  , helper = require('./helper')
  , nginios = helper.nginios
  , Gear = nginios.Gear
  , modelRegistry = require('../lib/nginios/db/model_registry');


var myGear = new Gear({});

describe( 'Gear', function(){

  it('creates a new gear', function(){
    expect( myGear ).to.be.instanceOf( Gear );
  })

  describe( 'after app initializiation', function(){

    before( function(){
      this.app = nginios();
    });

    it('has a gear.test gear defined', function(){
      expect( this.app.gears ).to.have.property('test');
    });

    it("has loaded the gear's app directory", function(){
      expect( modelRegistry.modelPaths ).to.contain( __dirname+'/app/models' );
    });

  });

});

