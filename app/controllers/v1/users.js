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

  // actions
  this.get('.html',
           login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
           function( req, res ){
             res.nginios.render('index');
           });

  this.get('/',
           login.ensureLoggedIn( this.resolvePath( null, '/login' ) ),
           this.getUsers,
           function( req, res ){
             res.json({ users: req.users });
           });

});



module.exports = UsersController;
