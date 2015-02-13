Caminio.IndexController = Ember.ObjectController.extend
  needs: ['application']
  activities: Em.A()
  sortedActivities: (->
    return unless @get('activities').get('isFulfilled')
    a = @get('activities').sortBy('created_at')
    a.reverse()
  ).property 'activities.@each'
  