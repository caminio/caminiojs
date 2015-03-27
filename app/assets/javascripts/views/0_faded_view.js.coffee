Caminio.FadedView = Ember.View.extend
  willAnimateIn: ->
    @$().css 'opacity', 0

  animateIn: (done)->
    @$().fadeTo 150, 1, =>
      @$('.js-get-focus').focus()
      done()

  animateOut: (done)->
    @$().fadeTo 200, 0, done
