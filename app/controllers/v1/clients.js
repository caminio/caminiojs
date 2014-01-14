var caminio = require('../../../')
  , login = require('connect-ensure-login')
  , Controller = caminio.Controller;

module.exports = Controller.define( function( app ){

  var auth = app.gears.caminio.auth
    , Client = caminio.orm.models.Client;

  // private
  this.getClients = function getClients( req, res, next ){
    caminio.orm.models.Client
    .find()
    .populate('owner')
    .exec( function( err, clients ){
      req.clients = clients;
      next(err);
    });
  }

  this.getClient = function getClients( req, res, next ){
    caminio.orm.models.Client
    .findOne({ _id: req.params.id })
    .populate('owner')
    .exec( function( err, client ){
      req.client = client;
      next(err);
    });
  }

  this.requireOwner = function requireOwner( req, res, next ){
    if( !req.client )
      return res.json(500, {error: 'client was not found'} );
    if( !res.locals.currentUser.isSuperUser() && res.locals.currentUser._id.eql(req.client.owner._id) )
      return res.json(401, { error: 'insufficient rights' });
    next();
  }

  // actions
  this.get('/',
          auth.ensureLogin,
          this.getClients,
          function( req, res ){
            res.json( { items: req.clients } );
          });

  this.post('/',
          auth.ensureLogin,
          this.requireOwner,
          function( req, res ){
            if( 'client' in req.body ){
              Client.create({ 
                token: utils.uid(64),
                secret: utils.uid(64),
                name: req.body.client.name,
                user: req.user 
              }, function( err, client ){
                if( err ){ return res.json(500, { error: err }); }
                res.json({ item: client });
              });
            } else
              res.json(500,{ error: 'Could not create client and owner for unknown reason' });
          });

  this.put('/:id',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getClient,
          this.requireOwner,
          function( req, res ){
            if( 'owner' in req.body && 'client' in req.body ){
              if( req.body.owner.email )
                req.client.owner.email = req.body.owner.email;
              if( req.body.owner.name.full )
                req.client.owner.name.full = req.body.owner.name.full;
              if( req.body.owner.password )
                req.client.owner.password = req.body.owner.password;
              req.client.owner.save( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                if( req.body.client.name )
                  req.client.name = req.body.client.name;
                if( req.body.client.plan )
                  req.client.plan = req.body.client.plan;
                if( req.body.client.plan in caminio.app.config.available_plans )
                  req.client.allowed_gears = caminio.app.config.available_plans[req.body.client.plan];
                req.client.save( function( err ){
                  if( err ){ return res.json(400, { error: err }); }
                  res.json({ item: req.client });
                });
              });
            } else
              res.json({ error: 'Could not create client and owner for unknown reason' });
          });

});

