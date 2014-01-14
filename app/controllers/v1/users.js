var caminio = require('../../../')
  , login = require('connect-ensure-login')
  , moment = require('moment')
  , Controller = caminio.Controller;

var UsersController = Controller.define( function( app ){

  var auth = app.gears.caminio.auth;

  // private
  this.getUsers = function getUsers( req, res, next ){
    caminio.orm.models.User
    .find({ 'domains': res.locals.currentDomain.id })
    .exec( function( err, users ){
      req.users = users;
      next(err);
    });
  }

  this.getUserById = function getUserById( req, res, next ){
    caminio.orm.models.User
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
          auth.ensureLogin,
          this.getUsers,
          function( req, res ){
            res.json( { items: req.users } );
          });

  this.get('/:id/edit',
          auth.ensureLogin,
          this.getUserById,
          function( req, res ){
            res.locals.user = req.user;
            res.caminio.render('edit');
          });

  this.get('/:id',
          auth.ensureLogin,
          this.getUserById,
          function( req, res ){
            res.json( { item: req.user } );
          });

  this.post('/',
          auth.ensureLogin,
          this.requireAdmin,
          function( req, res ){
            if( !res.locals.currentDomain )
              return res.json( 400, { error: 'no domain selected'});
            if( 'user' in req.body ){
              var user = new caminio.orm.models.User( req.body.user );
              user.domains.push( res.locals.currentDomain.id );
              user.save( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                if( user )
                  return res.json({ item: user });
                res.json({ error: 'Could not create user for unknown reason' });
              });
            }
          });

  this.put('/:id',
          auth.ensureLogin,
          this.getUserById,
          function( req, res ){
            
            if( !res.locals.currentUser.isAdmin( res.locals.currentDomain ) && !res.locals.currentUser._id.eql( req.user._id ) )
              return res.json(401, { error: 'insufficient_rights' });

            if( req.user && 'user' in req.body ){

              if( req.body.user.name && req.body.user.name.full ){
                req.body.user.name.first = req.body.user.name.full.split(' ')[0];
                req.body.user.name.last = req.body.user.name.full.replace( req.body.user.name.first + ' ', '');
              }

              if( req.body.user.name ){
                if( req.body.user.name.first && req.body.user.name.first.length > 0 )
                  req.user.name.first = req.body.user.name.first;

                if( req.body.user.name.last && req.body.user.name.last.length > 0 )
                  req.user.name.last = req.body.user.name.last;
              }

              if( req.body.user.email && req.body.user.email.length > 0 )
                req.user.email = req.body.user.email;

              if( req.body.user.password && req.body.user.password.length > 0 )
                req.user.password = req.body.user.password;

              if( req.body.user.lang && req.body.user.lang.length > 0 )
                req.user.lang = req.body.user.lang;


              req.user.save( function( err ){
                if( err ){ return res.json(400, { error: err }); }
                caminio.orm.models.User.findOne({ _id: req.params.id }, function( err, user ){
                  if( err ){ return res.json(400, { error: err }); }
                  if( user )
                    return res.json({ item: user });
                  res.json({ error: 'Could not create user for unknown reason' });
                });
              });
            }
          });

  this.put('/:id/lock',
          auth.ensureLogin,
          this.getUserById,
          this.requireAdmin,
          function( req, res ){
            if( req.user ){
              req.user.update( { locked: { at: new Date(), by: res.locals.currentUser } }, function( err ){
                if( err ){ return res.json(400, { error: err }); }
                caminio.orm.models.User.findOne({ _id: req.params.id }, function( err, user ){
                  if( err ){ return res.json(400, { error: err }); }
                  res.json({ item: user });
                });
              });
            } else
              res.json(404, { error: 'not_found' });
          });

  this.delete('/:id',
          auth.ensureLogin,
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
