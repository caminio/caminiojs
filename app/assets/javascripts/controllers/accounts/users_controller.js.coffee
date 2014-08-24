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
      @transitionToRoute('accounts.users.edit', record.get('id'))

    uninviteRecord: (record)->
      bootbox.confirm Em.I18n.t('accounts.users.really_uninvite'), (result)->
        if result
          record
            .destroyRecord()
            .then (user)->
              toastr.info Em.I18n.t('accounts.users.uninvited', name: record.get('name'))
            .catch (error)->
              toastr.error error.responseJSON

    addUser: ->
      @transitionToRoute('accounts.users.new')

App.EmberTableCheckboxTableCell = Ember.Table.CheckboxCell.extend
  templateName: 'accounts/users_checkbox_cell'

App.EmberTableCheckboxHeaderCell = Ember.Table.CheckboxHeaderCell.extend
  templateName: 'accounts/users_checkbox_cell'

