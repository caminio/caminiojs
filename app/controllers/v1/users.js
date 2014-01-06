var nginios = require('../../../')
  , login = require('connect-ensure-login')
  , moment = require('moment')
  , Controller = nginios.Controller;

var UsersController = Controller.define( function( app ){

  // private
  this.getUsers = function getUsers( req, res, next ){
    nginios.orm.models.User
    .find()
    .exec( function( err, users ){
      req.users = users;
      next(err);
    });
  }

  this.getUserById = function getUserById( req, res, next ){
    nginios.orm.models.User
    .findById( req.params.id )
    .exec( function( err, user ){
      req.user = user;
      next(err);
    })
  }

  this.requireAdmin = function requireAdmin( req, res, next ){
    if( !res.locals.currentUser.isAdmin( res.locals.currentDomain ) )
      return res.json(401, { error: 'insufficient rights' });
    next();
  }

  // actions
  this.get('/',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getUsers,
          function( req, res ){
            res.json( { items: req.users } );
          });

  this.get('/:id',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getUserById,
          function( req, res ){
            res.json( { item: req.user } );
          });

  this.post('/',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.requireAdmin,
          function( req, res ){
            if( 'user' in req.body ){
              nginios.orm.models.User.create( req.body.user, function( err, user ){
                if( err ){ return res.json(400, { error: err }); }
                if( user )
                  return res.json({ item: user });
                res.json({ error: 'Could not create user for unknown reason' });
              });
            }
          });

  this.put('/:id',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getUserById,
          this.requireAdmin,
          function( req, res ){
            if( req.user && 'user' in req.body ){
              req.user.update( req.body.user, function( err ){
                if( err ){ return res.json(400, { error: err }); }
                nginios.orm.models.User.findOne({ _id: req.params.id }, function( err, user ){
                  if( err ){ return res.json(400, { error: err }); }
                  if( user )
                    return res.json({ item: user });
                  res.json({ error: 'Could not create user for unknown reason' });
                });
              });
            }
          });

  this.put('/:id/lock',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getUserById,
          this.requireAdmin,
          function( req, res ){
            if( req.user ){
              req.user.update( { locked: { at: new Date(), by: res.locals.currentUser } }, function( err ){
                if( err ){ return res.json(400, { error: err }); }
                nginios.orm.models.User.findOne({ _id: req.params.id }, function( err, user ){
                  if( err ){ return res.json(400, { error: err }); }
                  res.json({ item: user });
                });
              });
            } else
              res.json(404, { error: 'not_found' });
          });

  this.delete('/:id',
          login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
          this.getUserById,
          this.requireAdmin,
          function( req, res ){
            if( req.user ){
              req.user.remove( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                  res.json({ item: req.user });
              });
            } else
              res.json(404, { error: 'not_found' });
          });
});



module.exports = UsersController;
