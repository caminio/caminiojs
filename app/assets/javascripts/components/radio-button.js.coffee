Caminio.RadioButtonComponent = Ember.Component.extend

  tagName: 'input'
  type: 'radio'
  attributeBindings: [ 'checked', 'name', 'type', 'value' ]

  checked: (->
    @get('value') == @get('groupValue')
  ).property 'value', 'groupValue'

  change: ->
    @set('groupValue', @get('value'))
