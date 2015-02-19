Caminio.SubscriptionsManageController = Ember.ObjectController.extend

  needs: ['application']
  availableApps: Em.A()
  hasChanges: false

  numUsers: 1

  taxRate: 20

  formattedTaxRate: (->
    "#{@get('taxRate')}%"
  ).property 'taxRate'

  taxRateSum: (->
    @get('total') - @get('sum')
  ).property 'total'

  formattedTaxRateSum: (->
    accounting.formatMoney @get('taxRateSum') / 100
  ).property 'taxRateSum'

  selectedPlans: Em.A()

  numUsersSum: (->
    @get('numUsers') * @get('pricePerUser')
  ).property 'numUsers'

  pricePerUser: 100

  formattedPricePerUser: (->
    accounting.formatMoney @get('pricePerUser') / 100
  ).property 'pricePerUser'

  formattedPriceNumUsers: (->
    return accounting.formatMoney(0) if @get('numUsers') < 2
    accounting.formatMoney @get('numUsers') * @get('pricePerUser') / 100
  ).property 'numUsers'

  # including tax rate!!
  total: (->
    sum = @get('pricePerUser') * @get('numUsers')
    if @get('numUsers') < 2
      sum = 0
    @get('selectedPlans').forEach (plan)->
      sum += plan.total_value
    sum
  ).property 'numUsers', 'selectedPlans.@each'

  # excluding tax rate!!
  sum: (->
    @get('total') * 100 / ( 100 + @get('taxRate'))
  ).property 'total'

  formattedSum: (->
    accounting.formatMoney @get('sum') / 100
  ).property 'total'

  formattedTotal: (->
    accounting.formatMoney @get('total') / 100
  ).property 'total'

  numUsersObserver: (->
    @set 'hasChanges', true
  ).observes 'numUsers'

  actions:

    startTour: ->
      user = @get('controllers.application.currentUser')
      Caminio.SubscriptionWalkthrough.start ->
        return if user.get('completed_tours').indexOf('subscriptions') >= 0
        user.get('completed_tours').push 'subscriptions'
        user.save()

    selectPlan: (plan)->
      if oldPlan = @get('selectedPlans').findBy('app_name', plan.app_name)
        @get('selectedPlans').removeObject(oldPlan)
      @get('selectedPlans').pushObject(plan)
      @set 'hasChanges', true

    save: ->
      return unless @get('hasChanges')
      data = { plans: [], users: @get('numUsers') }
      
      @get('selectedPlans').forEach (plan)=>
        data.plans.push { app_name: plan.app_name, name: plan.name }

      $.ajax
        url: "#{Caminio.get('apiHost')}/app_bills"
        type: 'post'
        contentType: 'application/json'
        data: JSON.stringify(data)
      .then (response)=>  
        noty
          type: 'success'
          text: Em.I18n.t('subscription.saved')