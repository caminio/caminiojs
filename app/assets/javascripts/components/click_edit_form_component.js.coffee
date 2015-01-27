Caminio.ClickEditFormComponent = Ember.Component.extend

  init: ->
    @_super()
    @set('origValue', '')
    @set('origValue', @get('value')) unless Em.isEmpty(@get('value'))
    @set('value','') if Em.isEmpty(@get('value'))
    if @get('focus')
      @set('editValue', true)
      Caminio.set('currentClickEdit', @)
      Em.run.later (-> @$('input:first').focus()), 500

  saveActionName: 'save'

  editValue: false

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  editValueObserver: (->
    Em.run.later =>
      @$('input[type=text]').focus()
    , 10
  ).observes 'editValue'

  hasChanges: Em.computed ->
    @get('origValue') != @get('value')
  .property 'origValue', 'value'

  valueObserver: (->
    return if @get('origValue') == @get('value')
  ).observes 'value'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  actions:

    saveChanges: ->
      @get('parentController').send(@get('saveActionName'), @saveCallback, @)

    cancelEdit: ->
      @set('editValue',false)
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

