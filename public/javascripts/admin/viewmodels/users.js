define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , moment = require('moment')
    , i18n = require('i18next')
    , User = require('viewmodels/user');

  initViewModel();

  var viewModel = {
    items: ko.observableArray(),
    i18n: i18n,
    activate: function(){
      return { title: 'biwoe'};
    }
  }

  return viewModel;

  function initViewModel(){
    getUsers();
  }

  function getUsers(){
    dataService.get('/v1/users')
    .find()
    .exec( function( err, users ){
      if( err ){ return console.log('error:', err); }
      viewModel.items = ko.observableArray();
      users.forEach( function(user_data){
        viewModel.items.push( new User(user_data) );
      });
    });
  }

});
