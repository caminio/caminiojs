App.AccountsUsersController = Em.ObjectController.extend
  numRows: 10

  columns: Ember.computed ->
    checkbox = Ember.Table.ColumnDefinition.create
      columnWidth: 50
      headerCellViewClass:  'App.EmberTableCheckboxHeaderCell'
      textAlign: 'text-align-left'
      isResizable: false
      contentPath: 'checked'
      tableCellViewClass:  'App.EmberTableCheckboxTableCell'
    
    columnNames = ['firstname', 'lastname', 'email','formattedLastLoginAt']
    columns = columnNames.map (key, index) ->
      Ember.Table.ColumnDefinition.create
        textAlign: 'text-align-left'
        headerCellName: Ember.I18n.t("accounts.users.#{key.w()}")
        contentPath: key
        isSortable: true
    
    columns.unshift checkbox
    columns
  .property()

  actions:

    editRecord: (record)->
      console.log "record", record

    addUser: ->
      @transitionToRoute('accounts.users.new')

App.EmberTableCheckboxTableCell = Ember.Table.CheckboxCell.extend
  templateName: 'accounts/users_checkbox_cell'

App.EmberTableCheckboxHeaderCell = Ember.Table.CheckboxHeaderCell.extend
  templateName: 'accounts/users_checkbox_cell'

