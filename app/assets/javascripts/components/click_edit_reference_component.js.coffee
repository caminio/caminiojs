Caminio.ClickEditReferenceComponent = Ember.Component.extend

  referenceTitleName: 'title'

  filter: ''

  filteredOptions: Em.computed ->
    return @get('options') if Em.isEmpty @get('filter')
    refTitleName = @get('referenceTitleName')
    refSubtitleName = @get('referenceSubtitleName')
    f = new RegExp(@get('filter'),'i')
    o = @get('options').filter (item)=>
      item.get(refTitleName).match f || item.get('refSubtitleName').match f
    o.sortBy( @get('referenceTitleName') )
  .property 'options.@each', 'filter'

  selectReferenceTrKey: 'select_reference'

  selectReferenceSubtitleTrKey: 'nothing_selected'

  selectReferenceTr: (->
    Em.I18n.t @get 'selectReferenceTrKey'
  ).property 'selectReferenceTrKey'

  referenceTitle: (->
    @get("reference.#{@get('referenceTitleName')}")
  ).property 'referenceTitleName'

  referenceSubtitle: (->
    return unless @get('referenceSubtitleName')
    @get("reference.#{@get('referenceSubtitleName')}")
  ).property 'referenceSubtitleName'

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  noFilterNoText: Em.computed ->
    @get('filteredOptions.length') < 1 && @get('filter.length') < 1
  .property 'filter', 'filteredOptions.length'

  actions:

    openModal: ->
      @get('parentController').send 'openMiniModal', 'select_reference_modal', @

    searchOrCreate: ->
      if @get('filteredOptions.length') < 1
        @get('parentController').send( @get('createNewReferenceAction'), @get('filter') )

    editDetails: ->
      console.log 'transition to', @get('editDetailsRouteName')
      @get('parentController').transitionToRoute(@get('editDetailsRouteName'))
      false


Caminio.SelectReferenceItemController = Em.ObjectController.extend

  isActive: (->
    @get("content.id") == @get('parentController.reference.id')
  ).property 'parentController.reference.id'

  getTitle: (->
    console.log @get('content.title')
    @get("content.#{@get('parentController.referenceTitleName')}")
  ).property 'content'

  getSubtitle: (->
    console.log @get('content.shortAddress')
    @get("content.#{@get('parentController.referenceSubtitleName')}")
  ).property 'content'


  actions:

    select: ->
      @get('parentController').set 'reference', @get 'content'