App.LabelsSidebarComponent = Em.Component.extend
 
  actions:

    newLabelModal: ->
      @set('newLabel', @get('parentController').store.createRecord('label', category: @get('category') ))
      @send('openModal', 'labels/edit')
