define(function(require) {

  var ko = require('knockout');

  return {
    customers: ko.observableArray(),
    activate: function(){
      this.customers = [{name: 'one'},{name:'two'}];
    }
  }
});
