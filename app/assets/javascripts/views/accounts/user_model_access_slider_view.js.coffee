App.AccountsUserModelAccessSliderView = Ember.View.extend
  tagName: 'input'
  classNames: 'slider'
  didInsertElement: ->
    console.log "controller", @get('controller.content')
    @$().slider
      tooltip: 'hide',
      min: 0,
      max: 100,
      step: 20,
      value: @get('controller.content.access_level')
    .on 'slideStop', (options)->
      @get('controller.content').set('access_level', options.value)
