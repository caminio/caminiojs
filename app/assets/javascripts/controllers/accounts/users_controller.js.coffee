App.AccountsUsersController = Em.ArrayController.extend
  numRows: 10
  itemController: 'accounts_user_table_item'

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

fixDropdown = ->
  @$('.dropdown-toggle').on 'click', ->
    $dropdownMenu = $(@).closest('.dropdown').find('.dropdown-menu')
    return if $dropdownMenu.data('fixed')
    $dropdownMenu.data('fixed',true)
    Ember.run.later (->
      $dropdownMenu.css
        left: $dropdownMenu.offset().left
        top: $dropdownMenu.offset().top
      .addClass('fixed')
    ), 50

App.EmberTableCheckboxTableCell = Ember.Table.TableCell.extend
  templateName: 'common/ember-table/checkbox_cell'
  classNames: 'ember-table-row-checkbox'
  didInsertElement: fixDropdown

App.EmberTableCheckboxHeaderCell = Ember.Table.HeaderCell.extend
  templateName: 'common/ember-table/checkbox_cell'
  classNames: 'ember-table-row-checkbox ember-table-header-row-checkbox'
  didInsertElement: fixDropdown

App.AccountsUserTableItemController = Em.ObjectController.extend
  actions:
    removeRecord: (record)->
      console.log "removing", record

    editRecord: (record)->
      console.log "eid"

