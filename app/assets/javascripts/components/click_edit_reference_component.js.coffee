Caminio.ClickEditReferenceComponent = Ember.Component.extend

  referenceTitleBinding: 'title'

  selectReferenceTrKey: 'select_reference'

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


  actions:

    openModal: ->
      @get('parentController').send 'openMiniModal', 'select_reference_modal', @
