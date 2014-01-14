define(function(require) {

  var QueryManager = require('query_manager')
    , ko = require('knockout');

  var viewModel = {
    items: ko.observableArray(),
    i18n: i18n,
    activate: function(){
    }
  }

  return viewModel;

  function getClients(){
  }

});
