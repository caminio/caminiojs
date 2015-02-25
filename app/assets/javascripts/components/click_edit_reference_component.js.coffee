Caminio.ClickEditReferenceComponent = Ember.Component.extend

  referenceTitleBinding: 'title'

  filter: ''

  filteredOptions: Em.computed ->
    return @get('options') if Em.isEmpty @get('filter')
    @get('options').filterBy( @get('referenceTitleBinding'), @get('filter') )
  .property 'options.@each', 'filter'

  selectReferenceTrKey: 'select_reference'

  selectReferenceSubtitleTrKey: 'nothing_selected'

  selectReferenceTr: (->
    Em.I18n.t @get 'selectReferenceTrKey'
  ).property 'selectReferenceTrKey'

  referenceTitle: (->
    @get("reference.#{@get('referenceTitleBinding')}")
  ).property 'referenceTitleBinding'

  referenceSubtitle: (->
    return unless @get('referenceSubtitleBinding')
    @get("reference.#{@get('referenceSubtitleBinding')}")
  ).property 'referenceSubtitleBinding'

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  noFilterNoText: Em.computed ->
    @get('filteredOptions.length') < 1 && @get('filter.length') < 1
  .property 'filter', 'filteredOptions.length'

  actions:

    openModal: ->
      @get('parentController').send 'openMiniModal', 'select_reference_modal', @


Caminio.SelectReferenceItemController = Em.ObjectController.extend

  isActive: (->
    @get("content.id") == @get('parentController.reference.id')
  ).property 'parentController.reference.id'