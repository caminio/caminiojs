var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , caminio = helper.caminio;


describe( 'Group', function(){

  describe( 'properties', function(){

    before( function(){
      this.group = fixtures.group.build();
    });

    it('is instance of User', function(){
      expect( this.group ).to.be.instanceOf( caminio.orm.models.Group );
    });
  
    it('has .name', function(){
      expect( this.group.name ).to.eq( helper.fixtures.group.attributes().name );
    });

    it('has .description', function(){
      expect( this.group.description ).to.eq( helper.fixtures.group.attributes().description );
    });

    it('has many .messages (embedded)', function(){
      expect( this.group.messages ).to.be.an('array');
    });

    it('has many .users (ref)', function(){
      expect( this.group.users ).to.be.an('array');
    });

  });

  describe('methods', function(){

    describe('users membership', function(){
      
      before( function( done ){
        var self = this;
        caminio();
        async.parallel({
          group: function( callback ){
            fixtures.group.create( callback );
          },
          user: function( callback ){
            fixtures.user.create( callback );
          }
        }, function( err, results ){
          self.group = results.group;
          self.user = results.user;
          self.group.users.push( self.user );
          done();
        });
      });

      it('has one group membership', function(){
        expect(this.group.users).to.have.length.of(1);
        expect(this.group.users[0].toString()).to.eq(this.user.id.toString());
      });

    });

  });

});
