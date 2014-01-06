define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , moment = require('moment');

  initViewModel();

  var User = function User( data ){
    
    for( var i in data )
      this[i] = data[i];

    this.email = ko.observable( data.email || '');

    this.name = {
      last: ko.observable(data.name.last || ''),
      first: ko.observable(data.name.first || ''),
    };
    this.name.full = ko.computed( function(){ 
      return this.name.first()+' '+this.name.last(); 
    }, this);

    this.last_login_at = ko.computed( function(){
      return moment(this.last_login.at).fromNow();
    }, this);

  }

  var viewModel = {
    items: ko.observableArray(),
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

  function querySucceeded(data){
    data.items.forEach( function( item ){
      viewModel.items.push( item );
    });
  }

});
