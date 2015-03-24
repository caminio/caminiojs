# coffeelint: disable=max_line_length
Caminio.ClickEditSelectCountryComponent = Ember.Component.extend

  countries: (->
    Em.A( countryCodes[LANG].map (c)-> Em.Object.create(c) )
  ).property ''

  valueSaved: false
  valueSaving: false

  saveActionName: 'save'

  optionLabelPath: 'name'
  optionValuePath: 'code'

  selectedCountryName: (->
    country = @get('countries').findBy('code', @get('value'))
    country.get('name')
  ).property 'value'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaving', false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  obj: (->
    obj = countryCodes[LANG].findBy( @get('optionValuePath'), @get('value') )
    Em.Object.create obj
  ).property 'value'

  actions:

    openModal: ->
      @get('targetObject').send 'openMiniModal', 'select_for_country_edit', @

    select: (content)->
      content = Em.Object.create(content)
      @set 'value', content.get( @get('optionValuePath') )
      $('.mini-modal .close').click()
      return if @get 'content.isNew'
      @set('valueSaving', true)
      @get('targetObject').send(@get('saveActionName'), @saveCallback, @)

Caminio.SelectOptionItemController = Em.ObjectController.extend

  isActive: (->
    @get("content.#{@get('parentController.optionValuePath')}") == @get('parentController.value')
  ).property 'parentController.value'
