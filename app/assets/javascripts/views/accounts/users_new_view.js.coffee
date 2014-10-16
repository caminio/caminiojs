App.AccountsUsersNewView = Ember.View.extend
  layoutName: 'accounts/layout'
  didInsertElement: ->
    @$('.js-get-focus').focus();
