Caminio.ClickEditReferenceComponent = Ember.Component.extend

  referenceTitleName: 'title'

  filter: ''
  saveActionName: 'save'

  filteredOptions: Em.computed ->
    return @get('options') if Em.isEmpty @get('filter')
    refTitleName = @get('referenceTitleName')
    refSubtitleName = @get('referenceSubtitleName')
    f = new RegExp(@get('filter'),'i')
    o = @get('options').filter (item)=>
      (!Em.isEmpty(item.get(refTitleName)) && item.get(refTitleName).match f) || 
      (!Em.isEmpty(item.get(refSubtitleName)) && item.get(refSubtitleName).match f)
    o.sortBy( @get('referenceTitleName') )
  .property 'options.@each', 'filter'

  selectReferenceTrKey: 'select_reference'

  selectReferenceSubtitleTrKey: 'nothing_selected'

  selectReferenceTr: (->
    Em.I18n.t @get 'selectReferenceTrKey'
  ).property 'selectReferenceTrKey'

  labelTranslation: (->
    Em.I18n.t @get('label')
  ).property 'label'

  referenceTitle: (->
    @get("reference.#{@get('referenceTitleName')}") || Em.I18n.t('no_title_set')
  ).property 'referenceTitleName'

  referenceSubtitle: (->
    return unless @get('referenceSubtitleName')
    @get("reference.#{@get('referenceSubtitleName')}")
  ).property 'referenceSubtitleName'

  noFilterNoText: Em.computed ->
    @get('filteredOptions.length') < 1 && @get('filter.length') < 1
  .property 'filter', 'filteredOptions.length'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  actions:

    openModal: ->
      @get('parentController').send 'openMiniModal', 'select_reference_modal', @

    searchOrCreate: ->
      if @get('filteredOptions.length') < 1
        @get('parentController').send( @get('createNewReferenceAction'), @get('filter'), @ )

    editDetails: (content)->
      $('.modal-content .close').click()
      @get('parentController').transitionToRoute( @get('editDetailsRouteName'), content.id )
      false


Caminio.SelectReferenceItemController = Em.ObjectController.extend

  isActive: (->
    @get("content.id") == @get('parentController.reference.id')
  ).property 'parentController.reference.id'

  getTitle: (->
    @get("content.#{@get('parentController.referenceTitleName')}")
  ).property 'content'

  getSubtitle: (->
    @get("content.#{@get('parentController.referenceSubtitleName')}")
  ).property 'content'

  actions:

    select: ->
      @get('parentController').set 'reference', @get 'content'
      $('.modal-content .close').click()
      content = @get('parentController.targetObject.content')
      if content.get 'isNew'
        return
      @set 'valueSaving', true
      @get('parentController.targetObject').send(@get('parentController.saveActionName'), @get('parentController').saveCallback, @)