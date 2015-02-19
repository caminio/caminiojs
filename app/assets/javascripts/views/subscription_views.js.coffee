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

    $('.slider').Link('lower').to( $('#users-preview'), 'html')

    user = @get('controller.controllers.application.currentUser')
    if user.get('completed_tours').indexOf('subscriptions') < 0
      @get('controller').send('startTour')


Caminio.SubscriptionsConfirmChangeView = Caminio.FadedView.extend()