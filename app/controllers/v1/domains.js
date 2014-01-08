var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = nginios.Controller;

var DomainsController = Controller.define( function( app ){

  // private
  this.getDomains = function getDomains( req, res, next ){
    nginios.orm.models.Domain
    .find()
    .populate('owner')
    .exec( function( err, domains ){
      req.domains = domains;
      next(err);
    });
  }

  this.getDomain = function getDomains( req, res, next ){
    nginios.orm.models.Domain
    .findOne({ _id: req.params.id })
    .populate('owner')
    .exec( function( err, domain ){
      req.domain = domain;
      next(err);
    });
  }


  this.requireSU = function requireSU( req, res, next ){
    if( !res.locals.currentUser.isSuperUser() )
      return res.json(401, { error: 'insufficient rights' });
    next();
  }

  this.requireOwner = function requireOwner( req, res, next ){
    if( !req.domain )
      return res.json(500, {error: 'domain was not found'} );
    if( !res.locals.currentUser.isSuperUser() && res.locals.currentUser._id.eql(req.domain.owner._id) )
      return res.json(401, { error: 'insufficient rights' });
    next();
  }


  // actions
  this.get('/',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getDomains,
          function( req, res ){
            res.json( { items: req.domains } );
          });

  this.post('/',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.requireSU,
          function( req, res ){
            if( 'owner' in req.body && 'domain' in req.body ){
              var owner = new nginios.orm.models.User( req.body.owner );
              owner.save( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                var domain = new nginios.orm.models.Domain( req.body.domain );
                domain.owner = owner;
                if( req.body.domain.plan in nginios.app.config.available_plans )
                  domain.allowed_gears = nginios.app.config.available_plans[req.body.domain.plan];
                domain.save( function( err ){
                  if( err ){ return res.json(400, { error: err }); }
                  owner.domains.push( domain );
                  owner.role = 1;
                  owner.save( function( err ){
                    if( err ){ return res.json(400, { error: err }); }
                    domain.populate('owner', function( err, domain ){
                      if( err ){ return res.json(400, { error: err }); }
                      res.json({ item: domain });
                    })
                  });
                });
              });
            } else
              res.json({ error: 'Could not create domain and owner for unknown reason' });
          });

  this.put('/:id',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getDomain,
          this.requireOwner,
          function( req, res ){
            if( 'owner' in req.body && 'domain' in req.body ){
              if( req.body.owner.email )
                req.domain.owner.email = req.body.owner.email;
              if( req.body.owner.name.full )
                req.domain.owner.name.full = req.body.owner.name.full;
              if( req.body.owner.password )
                req.domain.owner.password = req.body.owner.password;
              req.domain.owner.save( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                if( req.body.domain.name )
                  req.domain.name = req.body.domain.name;
                if( req.body.domain.plan )
                  req.domain.plan = req.body.domain.plan;
                if( req.body.domain.plan in nginios.app.config.available_plans )
                  req.domain.allowed_gears = nginios.app.config.available_plans[req.body.domain.plan];
                req.domain.save( function( err ){
                  if( err ){ return res.json(400, { error: err }); }
                  res.json({ item: req.domain });
                });
              });
            } else
              res.json({ error: 'Could not create domain and owner for unknown reason' });
          });

});

module.exports = DomainsController;

