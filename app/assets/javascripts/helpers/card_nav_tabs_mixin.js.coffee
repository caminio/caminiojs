Caminio.CardNavTabsMixin = Ember.Mixin.create

  didInsertElement: ->
    @$('.card-nav-wrap > div').hide()
    @$('.card-nav-wrap > nav a').on 'click', (e)->
      e.preventDefault()
      id = $(@).attr('href')
      $(@).closest('.card-nav-wrap').find('nav a').removeClass('active')
      $(@).addClass('active')
      $(@).closest('.card-nav-wrap').find('>div').hide()
      $(@).closest('.card-nav-wrap').find(id).fadeIn(200)
    @$('.card-nav-wrap > nav a[data-select-first]').click()
    @_super()
