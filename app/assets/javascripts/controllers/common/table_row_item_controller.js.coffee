App.TableRowItemController = Em.ObjectController.extend

  isSelected: (->
    !!@get('parentController.selectedRows').findBy 'id', @get('content.id')
  ).property 'parentController.selectedRows.[]'

  actions:

    selectRow: ->
      if @get('isSelected')
        @get('parentController.selectedRows').removeObject @get('content')
      else
        @get('parentController.selectedRows').pushObject @get('content')

