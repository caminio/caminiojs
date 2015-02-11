Caminio.SubscriptionsManageController = Ember.ObjectController.extend
  needs: ['application']
  availablePlans: Em.A()

  actions:

    selectPlan: (plan)->
      bootbox.confirm Em.I18n.t('subscriptions.really_switch_to_plan', title: plan.title), (proceed)=>
        return unless proceed
        @transitionToRoute 'subscriptions.confirm_change', plan