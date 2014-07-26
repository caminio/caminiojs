App.SessionsNewView = Ember.View.extend
  didInsertElement: ->
    @.$('input[type=text]:first').focus()
