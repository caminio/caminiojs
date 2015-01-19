Caminio.IndexView = Em.View.extend
  layoutName: 'accounts/layout'
  willAnimateIn: ->
    @$().css("opacity", 0)

  animateIn: (done)->
    @$().fadeTo(500, 1, done)

  animateOut: (done)->
    @$().fadeTo(500, 0, done)
