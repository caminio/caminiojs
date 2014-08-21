App.AccountsUserModelAccessSliderView = Ember.View.extend
  tagName: 'input'
  classNames: 'slider'
  didInsertElement: ->
    console.log "controller", @get('controller.content')
    @$().slider
      tooltip: 'hide',
      min: ACCESS.NONE,
      max: ACCESS.FULL,
      step: 1,
      value: @get('controller.content.access_level')
    .on 'slideStop', (options)->
      @get('controller.content').set('access_level', options.value)
