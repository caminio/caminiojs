App.TableRowItemController = Em.ObjectController.extend

  actions:

    selectRow: ->
      if @get('content.isSelected')
        @get('parentController.selectedRows').removeObject @get('content')
        @get('content').set('isSelected',false)
      else
        @get('parentController.selectedRows').pushObject @get('content')
        @get('content').set('isSelected',true)

