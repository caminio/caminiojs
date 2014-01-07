define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , moment = require('moment')
    , i18n = require('i18next')
    , UserModel = require('models/user');

  var viewModel = {
    items: ko.observableArray(),
    i18n: i18n,
    activate: function(){
      getUsers();
    }
  }

  return viewModel;

  function getUsers(){
    dataService.get('/v1/users')
    .find()
    .exec( function( err, users ){
      if( err ){ return console.log('error:', err); }
      viewModel.items = ko.observableArray();
      users.forEach( function(user_data){
        viewModel.items.push( new UserModel(user_data) );
      });
    });
  }

});
