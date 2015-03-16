Caminio.ClickEditTextComponent = Ember.Component.extend

  saveClickComponent: (e)->
    return unless $('.editing-click-form').length
    return if $(e.target).hasClass('.editing-click-form')
    return if $(e.target).closest('.editing-click-form').length
    @send 'saveChanges'

  init: ->
    @_super()
    
    $(document)
      .off('click', $.proxy(@saveClickComponent, @))
      .on('click', $.proxy(@saveClickComponent, @))

    if @get('focus')
      @set('editValue', true)
      Caminio.set('currentClickEdit', @)
      Em.run.later (-> @$('input:first').focus()), 500

  saveActionName: 'save'

  value: ''
  origValue: undefined
  editValue: false
  valueSaved: false
  valueSaving: false

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  trPlaceholder: (->
    if @get('placeholder')
      return @get 'placeholder'
    return '' if Em.isEmpty @get('placeholder')
    Em.I18n.t @get('placeholderKey')
  ).property 'placeholder', 'placeholderKey'

  editValueObserver: (->
    Em.run.later =>
      @$('input[type=text]').focus()
    , 10
  ).observes 'editValue'

  hasChanges: Em.computed ->
    @get('origValue') != @get('value')
  .property 'origValue', 'value'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  didInsertElement: ->
    @$('.field-row').on 'keydown', 'input:first', (e)=>
      return unless e.keyCode == 9 # TAB KEY
      if e.shiftKey
        $nextView = @$().prev('.ember-view')
      else
        $nextView = @$().next('.ember-view')
      $nextFieldRow = $nextView.find('.field-row')
      if $nextFieldRow
        $nextFieldRow.find('.field-content').click()
      @.send('saveChanges')

    Em.run.later =>
      @set 'origValue', @get('value')
    , 100

  actions:

    saveChanges: ->
      if @get 'content.isNew'
        return @set 'editValue', false
      return if @get('value') == @get('origValue')
      @set 'editValue', false
      @set 'valueSaving', true
      @get('parentController').send(@get('saveActionName'), @saveCallback, @)

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

