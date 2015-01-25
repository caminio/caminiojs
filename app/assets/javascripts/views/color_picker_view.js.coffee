Caminio.ColorPickerView = Ember.Select.extend

  didInsertElement: ->
    @_super()
    @$('option').each -> $(@).attr('data-color', $(@).val())
    @$().colorselector()


  change: ->
    @get('controller').send(@get('onChangeAction'))