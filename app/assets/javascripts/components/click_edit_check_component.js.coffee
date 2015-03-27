# coffeelint: disable=max_line_length
Caminio.ClickEditCheckComponent = Ember.Component.extend

  valueSaved: false
  valueSaving: false
  value: null

  saveActionName: 'save'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  actions:

    toggleCheck: ->
      @toggleProperty 'value'
      return if @get 'content.isNew'
      @set('valueSaving', true)
      @get('targetObject').send(@get('saveActionName'), @saveCallback, @)

    cancelEdit: ->
      @set 'editValue', false
      @set 'value', @get('origValue')
      Caminio.get('currentClickEdit', null)

    edit: ->
      return if @get('editValue')
      other = Caminio.get('currentClickEdit') 
      if other && !other.isDestroyed && other != @
        other.set('editValue',false)
      @set('editValue', true)
      Caminio.set('currentClickEdit', @)
      Em.run.later =>
        @$('input:first').focus()
      , 300