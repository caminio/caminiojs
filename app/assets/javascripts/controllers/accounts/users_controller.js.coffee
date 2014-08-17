App.AccountsUsersController = Em.ArrayController.extend
  numRows: 10

  columns: Ember.computed ->
    columnNames = ['id', 'email']
    columns = columnNames.map (key, index) ->
      Ember.Table.ColumnDefinition.create
        columnWidth: 150
        headerCellName: key.w()
        contentPath: key
    columns
  .property()

