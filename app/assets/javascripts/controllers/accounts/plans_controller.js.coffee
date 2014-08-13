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
      currentUser = @store.getById('user',@get('controllers.sessions.currentUser.id'))
      return if currentUser.get('current_organizational_unit.app_plans').contains( app_plan )
      currentUser.get('current_organizational_unit.app_plans').pushObject( app_plan ) 
      @store.getById('user', currentUser.id).send('becomeDirty')

    savePlans: ->
      currentUser = @get('controllers.sessions.currentUser')
      plan_ids = currentUser.get('current_organizational_unit.app_plans').mapBy('id')
      if plan_ids.length < 1
        @send('openModal', 'accounts/available_plans')
        return toastr.error( Em.I18n.t('accounts.plans.select_at_least_one') )
      Ember.$.ajax(
        url: "/caminio/organizational_units/#{currentUser.get('current_organizational_unit.id')}/app_plans"
        type: 'put'
        data:
          plan_ids: plan_ids
      ).then ->
        toastr.info( Em.I18n.t('accounts.plans.updated' ) )

    removePlan: (app_plan)->
      currentUser = @get('controllers.sessions.currentUser')
      currentUser.get('current_organizational_unit.app_plans').removeObject( app_plan )
