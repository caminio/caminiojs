App.AccountsPlansController = Em.ObjectController.extend
  needs: ['sessions']
  myPlans: null
  availableApps: null
  apps: null
  availableLangs: ['de','en']

  actions:

    addPlan: (app_plan)->
      currentUser = @store.getById('user',@get('controllers.sessions.currentUser.id'))
      return if App.get('currentOu.app_plans').contains( app_plan )
      App.get('currentOu.app_plans').pushObject( app_plan ) 
      @store.getById('user', currentUser.id).send('becomeDirty')

    savePlans: ->
      controller = @
      currentUser = @get('controllers.sessions.currentUser')
      plan_ids = App.get('currentOu.app_plans').mapBy('id')
      if plan_ids.length < 1
        @send('openModal', 'accounts/available_plans')
        return toastr.error( Em.I18n.t('accounts.plans.select_at_least_one') )
      Ember.$.ajax(
        url: "/caminio/organizational_units/#{App.get('currentOu.id')}/app_plans"
        type: 'put'
        data:
          plan_ids: plan_ids
      ).then ->
        App.get('currentUser').save()
        $('.modal .close').click();
        toastr.info( Em.I18n.t('accounts.plans.updated' ) )

    removePlan: (app_plan)->
      App.get('currentOu.app_plans').removeObject( app_plan )
