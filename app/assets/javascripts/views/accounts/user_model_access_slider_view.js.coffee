App.AccountsUserModelAccessSliderView = Ember.View.extend
  tagName: 'input'
  classNames: 'slider'
  didInsertElement: ->
    content = @get('controller.content')
    @$().slider
      tooltip: 'hide',
      min: ACCESS.NONE,
      max: ACCESS.FULL,
      step: 1,
      value: @get('controller.content.access_level')
    .on 'slide', (options)->
      content.set('access_level', options.value)
