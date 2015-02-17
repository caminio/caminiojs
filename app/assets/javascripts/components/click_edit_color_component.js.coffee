# coffeelint: disable=max_line_length
Caminio.ClickEditColorComponent = Ember.Component.extend

  valueSaved: false
  valueSaving: false

  saveActionName: 'save'

  optionLabelPath: 'label'
  optionValuePath: 'value'

  modalHeader: 'please_select'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  obj: (->
    obj = @get('content').findBy( @get('optionValuePath'), @get('value') )
    Em.Object.create obj
  ).property 'value', 'content.@each'

  getLabelName: (->
    @get('obj').get( @get('optionLabelPath') )
  ).property 'value', 'content.@each'

  getModalHeader: (->
    Em.I18n.t @get('modalHeader')
  ).property ''

  actions:

    openModal: ->
      @get('parentController').send 'openMiniModal', 'select_for_click_edit', @

    select: (content)->
      content = Em.Object.create(content)
      @set 'value', content.get( @get('optionValuePath') )
      $('.mini-modal .close').click()
      return if @get 'content.isNew'
      @set('valueSaving', true)
      @get('parentController').send(@get('saveActionName'), @saveCallback, @)

Caminio.SelectOptionItemController = Em.ObjectController.extend

  isActive: (->
    @get("content.#{@get('parentController.optionValuePath')}") == @get('parentController.value')
  ).property 'parentController.value'