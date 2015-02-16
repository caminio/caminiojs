Caminio.ClickEditRadioComponent = Ember.Component.extend

  valueSaved: false
  valueSaving: false

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

  didInsertElement: ->
    console.log 'init', @get('content')

  actions:

    saveChanges: ->
      if @get 'content.isNew'
        return @set 'editValue', false
      @set('valueSaving', true)
      @get('parentController').send(@get('saveActionName'), @saveCallback, @)

    cancelEdit: ->
      @set('editValue',false)
      @set('value', @get('origValue'))
      Caminio.get('currentClickEdit', null)

Caminio.ClickEditRadioItemController = Em.ObjectController.extend
  
  getLabel: (->
    console.log "content.#{parentController.get('optionLabelPath')}"
    @get("content.#{parentController.get('optionLabelPath')}")
  ).property ''