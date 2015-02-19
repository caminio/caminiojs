Caminio.SubscriptionsManageRoute = Caminio.AuthenticatedRoute.extend

  setupController: (controller,model)->
    @_super controller, model

    currentOrganization = @controllerFor('application').get('currentOrganization')

    latestBill = currentOrganization.get('last_paid_bill')
    if latestBill && users = latestBill.get('app_bill_entries').findBy('app_name', 'users')
      controller.set 'numUsers', parseInt( users.get('name') )

    $.getJSON( "#{Caminio.get('apiHost')}/organizations/#{currentOrganization.id}/app_plans" )
    .then (data)=>
      controller.get('availableApps').clear()
      for key, raw_app of data.app_plans
        app = 
          name: key
          plans: Em.A()
        for key2, plan of raw_app
          plan.name = key2
          plan.app_name = key
          plan.unique_name = "#{key}-#{key2}"
          plan.formatted_total_value = accounting.formatMoney(plan.total_value/100)
          app.plans.pushObject( plan )
        controller.get('availableApps').pushObject( app )

      if latestBill
        latestBill.get('app_bill_entries').forEach (entry)=>
          app = controller.get('availableApps').findBy('name', entry.get('app_name'))
          if app
            plan = app.plans.findBy('name', entry.get('name'))
            controller.get('selectedPlans').pushObject plan


  model: ->
    @controllerFor('application').get('currentUser.organization')
