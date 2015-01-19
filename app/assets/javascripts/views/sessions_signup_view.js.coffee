Caminio.SessionsSignupView = Caminio.FadedView.extend
  didInsertElement: ->
    Ember.run.later =>
      $('input[type=text]:first').focus()
    , 500
