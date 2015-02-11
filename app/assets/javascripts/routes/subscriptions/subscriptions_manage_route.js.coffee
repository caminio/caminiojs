Caminio.SubscriptionsManageRoute = Caminio.AuthenticatedRoute.extend

  setupController: (controller,model)->
    @_super controller, model

    currentOrganization = @controllerFor('application').get('currentOrganization')
    $.getJSON( "#{Caminio.get('apiHost')}/organizations/#{currentOrganization.id}/app_plans" )
    .then (data)=>
      controller.get('availablePlans').clear()
      for key, value of data.app_plans
        value.name = key
        controller.get('availablePlans').pushObject( value )

  model: ->
    @controllerFor('application').get('currentUser')
