Caminio.UsersLayoutView = Caminio.FadedView.extend
  layoutName: 'settings/layout'

#
# INDEX
#
Caminio.UsersIndexView = Caminio.UsersLayoutView.extend()

#
# NEW
#
Caminio.UsersNewView = Ember.View.extend
  willAnimateIn: ->
    @$().css 'opacity', 0

  animateIn: (done)->
    @$().fadeTo 500, 1, =>
      @$('.js-get-focus').focus()
      done()

  animateOut: (done)->
    @$().fadeTo 500, 0, done


#
# EDIT
#
Caminio.UsersEditView = Caminio.UsersLayoutView.extend()
