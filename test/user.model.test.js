var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , nginuous = helper.nginuous;


describe( 'User', function(){

  describe( 'properties', function(){

    before( function(){
      this.user = fixtures.user.build();
    });
  
    it('has .name.first', function(){
      expect( this.user.name.first ).to.eq( this.user.name.first );
    });

    it('has .name.last', function(){
      expect( this.user.name.last ).to.eq( this.user.name.last );
    });

    it('has .email', function(){
      expect( this.user.email ).to.eq( this.user.email );
    });

    it('has .description', function(){
      expect( this.user.description ).to.eq( this.user.description );
    });

    it('has .phone', function(){
      expect( this.user.phone ).to.eq( this.user.phone );
    });

    it('has .encryptedPassword', function(){
      expect( this.user.encryptedPassword ).to.have.length(64);
    });

    it('has many .messages (embedded)', function(){
      expect( this.user.messages ).to.be.an('array');
    });

    it('has many .loginLog (embedded)', function(){
      expect( this.user.loginLog ).to.be.an('array');
    });

    it('has many .groups (ref)', function(){
      expect( this.user.groups ).to.be.an('array');
    });

    it('has many .domains (ref)', function(){
      expect( this.user.groups ).to.be.an('array');
    });

    it('has .preferences (nested)', function(){
      expect( this.user.preferences ).to.be.a('object');
    });

    it('returns .name.full (virtual)', function(){
      expect( this.user.name.full ).to.eq( this.user.name.first+' '+this.user.name.last );
    });

    it('returns .password (virtual)', function(){
      expect( this.user.password ).to.eq( this.user.password );
    });

    it('returns number of unreadMessages (virtual)', function(){
      expect( this.user.unreadMessages ).to.eq(0);
    });

  });

  describe('methods', function(){

    it('returns a salt for the user', function(){
      expect( this.user.generateSalt() ).to.have.length.above(9);
    });

    describe('authenticate', function(){

      it('valid password', function(){
        expect( this.user.authenticate( this.user.password ) ).to.be.true;
      });

      it('no password', function(){
        expect( this.user.authenticate('') ).not.to.be.true;
      });

      it('invalid password', function(){
        expect( this.user.authenticate('10326Test!') ).not.to.be.true;
      });

    });

    describe('group membership', function(){
      
      before( function( done ){
        var self = this;
        nginuous();
        async.parallel({
          user: function( callback ){
            fixtures.user.create( callback );
          },
          group: function( callback ){
            fixtures.group.create( callback );
          }
        }, function( err, results ){
          self.group = results.group;
          self.user = results.user;
          self.user.groups.push( self.group );
          done();
        });
      });

      it('has one group membership', function(){
        expect(this.user.groups).to.have.length.of(1);
        expect(this.user.groups[0].toString()).to.eq(this.group.id.toString());
      });

    });

  });

});
