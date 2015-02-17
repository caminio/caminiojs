# coffeelint: disable=max_line_length
Caminio.ClickEditRadioComponent = Ember.Component.extend

  valueSaved: false
  valueSaving: false

  saveActionName: 'save'

  optionLabelPath: 'label'
  optionValuePath: 'id'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  actions:

    select: (content)->
      @set 'value', content.get @get('optionValuePath')
      return if @get 'content.isNew'
      @set('valueSaving', true)
      @get('parentController').send(@get('saveActionName'), @saveCallback, @)

Caminio.ClickEditRadioItemController = Em.ObjectController.extend
  
  isActive: (->
    @get("content.#{@get('parentController.optionValuePath')}") == @get('parentController.value')
  ).property 'content', 'parentController.value'

  getLabelName: (->
    @get("content.#{@get 'parentController.optionLabelPath'}")
  ).property 'content'

  getLabelClasses: (->
    base = @get('content.classNames') || 'btn btn-default'
    if @get('isActive')
      base += ' ' + (@get('content.activeClassNames') || 'btn-primary')
    base
  ).property 'content.classNames', 'isActive'