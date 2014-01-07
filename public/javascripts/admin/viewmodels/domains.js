define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , moment = require('moment')
    , i18n = require('i18next')
    , DomainModel = require('models/domain');

  var viewModel = {
    items: ko.observableArray(),
    i18n: i18n,
    activate: function(){
      getDomains();
    }
  }

  return viewModel;

  function getDomains(){
    dataService.get('/v1/domains')
    .find()
    .exec( function( err, domains ){
      console.log('got', domains);
      if( err ){ return console.log('error:', err); }
      viewModel.items = ko.observableArray();
      domains.forEach( function(domain_data){
        viewModel.items.push( new DomainModel(domain_data) );
      });
    });
  }

});
