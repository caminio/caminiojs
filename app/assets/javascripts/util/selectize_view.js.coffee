#
# selectize.js extension view for integration in emberjs
#
# example:
#
# 1. array of objects
#
#   {{view App.SelectizeView
#          contentBinding="my_array"
#          optionValuePath="content.id"
#          optionLabelPath="content.label"
#          selectionBinding="my_binding"}}
#
# 2. array of strings
#
#   {{view App.SelectizeView
#          contentBinding='my_array_of_strings'
#          valueBinding='Vienna'}}
#
App.SelectizeView = Ember.Select.extend

  prompt: Em.I18n.t('please_select')
  classNames: ['input-xlarge']

  willInsertElement: ->
    if @get('promptTranslation')
      @set('prompt', @get('promptTranslation'))

  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', @, 'processChildElements'

  processChildElements: ->
    options =
      create: true

    @$()
      .selectize( options )
      .on('change', (->
        @$().selectize('setValue', @get('content.firstObject.id'))
      ).bind(@))

    willDestroyElement: ->
      @$().selectize().destroy()

    selectedDidChange: (->
      Em.run.later(@,(->
        return unless @$()
        @$().select2('val', @get('value'))
      ),100)
    ).observes 'selection.@each'

