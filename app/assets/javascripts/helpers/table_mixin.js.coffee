Caminio.TableMixin = Ember.Mixin.create
  filter: null

  loadData: ->
    console.log 'here', @get('filter')
