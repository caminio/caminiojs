App.SortableTableComponent = Ember.Table.EmberTableComponent.extend
  onColumSort: (col,newIdx)->
    @_super(col,newIdx)
    console.log "col", col.get('headerCellName')

  actions:
    sortByColumn: (col)->
      @sendAction('sortAction',col)

Em.Handlebars.helper('sortable-table-component', App.SortableTableComponent);
