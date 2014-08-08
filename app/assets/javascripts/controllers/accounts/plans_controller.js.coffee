App.AccountsPlansController = Em.ObjectController.extend
  needs: ['sessions']
  myPlans: null
  availableApps: null
  availableLangs: ['de','en']

  # myAppsObserver: (->
  #   
  # ).observes 'controllers.sessions.currentUser.current_organizational_unit.app_plans.@each'
  actions:

    addPlan: (app_plan)->
      currentUser = @get('controllers.sessions.currentUser')
      currentUser.get('current_organizational_unit.app_plans').pushObject( app_plan )
      console.log currentUser.get('current_organizational_unit.app_plans')

    savePlans: ->
      currentUser = @get('controllers.sessions.currentUser')
      plan_ids = currentUser.get('current_organizational_unit.app_plans').mapBy('id')
      Ember.$.ajax {
        url: "/caminio/organizational_units/#{currentUser.get('current_organizational_unit.id')}/app_plans"
        type: 'put'
        data:
          plan_ids: plan_ids
      }
      
