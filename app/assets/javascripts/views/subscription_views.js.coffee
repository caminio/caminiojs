Caminio.SubscriptionsManageView = Caminio.FadedView.extend
  layoutName: 'settings/layout'

  didInsertElement: ->
    $('.slider').noUiSlider
      start: @get('controller.numUsers')
      margin: 20
      step: 1
      range: 
        min: 1
        max: 20
      format: wNumb
        decimals: 0
    .on 'set', (e,val)=>
      @get('controller').set 'numUsers', parseInt(val)



Caminio.SubscriptionsConfirmChangeView = Caminio.FadedView.extend()