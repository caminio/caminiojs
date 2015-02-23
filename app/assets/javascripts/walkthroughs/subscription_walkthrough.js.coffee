Caminio.SubscriptionWalkthrough =
  start: (finished)->
    # $('body').pagewalkthrough
    #   name: 'introduction'
    #   steps: [
    #     {
    #       popup:
    #         content: Em.I18n.t('subscription.walkthrough.welcome')
    #         type: 'modal'
    #     }
    #     {
    #       wrapper: '.app-plans:first'
    #       popup:
    #         content: Em.I18n.t('subscription.walkthrough.select_plan')
    #         type: 'tooltip',
    #         position: 'top'
    #     }
    #     {
    #       wrapper: '.users-slider'
    #       popup:
    #         content: Em.I18n.t('subscription.walkthrough.select_num_users')
    #         type: 'tooltip',
    #         position: 'top'
    #     }
    #   ]

    # $('body').pagewalkthrough('show')

    tour = new Tour
      template: tooltipTourTemplate
      storage: false
      steps: [
        {
          orphan: true
          placement: 'top'
          title: Em.I18n.t('subscription.walkthrough.welcome.title')
          content: Em.I18n.t('subscription.walkthrough.welcome.body')
        }
        {
          placement: 'right'
          element: ".app-plan:first"
          title: Em.I18n.t('subscription.walkthrough.title')
          content: Em.I18n.t('subscription.walkthrough.select_plan')
        }
        {
          placement: 'top'
          element: ".users-slider"
          title: Em.I18n.t('subscription.walkthrough.title')
          content: Em.I18n.t('subscription.walkthrough.select_num_users')
        }
        {
          placement: 'right'
          element: ".price-sum tfoot td:last"
          title: Em.I18n.t('subscription.walkthrough.title')
          content: Em.I18n.t('subscription.walkthrough.overview_price')
        }
        {
          placement: 'right'
          element: ".save-plan .btn"
          title: Em.I18n.t('subscription.walkthrough.title')
          content: Em.I18n.t('subscription.walkthrough.checkout')
        }
        {
          placement: 'right'
          element: ".start-again"
          title: Em.I18n.t('subscription.walkthrough.title')
          content: Em.I18n.t('subscription.walkthrough.start_again')
        }
      ]
      onEnd: finished
    tour.init()
    tour.start()