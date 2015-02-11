Caminio.SubscriptionsConfirmChangeRoute = Caminio.AuthenticatedRoute.extend

  model: (params)->

    currentOrganization = @controllerFor('application').get('currentOrganization')
    $.getJSON( "#{Caminio.get('apiHost')}/organizations/#{currentOrganization.id}/app_plans" )
    .then (data)=>
      console.log params
      console.log data.app_plans[params.planName]
      return data.app_plans[params.planName]