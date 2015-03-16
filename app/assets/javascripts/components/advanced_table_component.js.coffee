Caminio.AdvancedTableComponent = Ember.Component.extend

  filter: null
  url: null
  limit: 30
  page: 0
  totalRows: 0
  columns: Em.A()
  rows: Em.A()

  selectedRows: Em.A()

  someRowsSelected: (->
    @get('selectedRows.length') > 0
  ).property 'selectedRows.length'

  allRowsSelected: (->
    @get('selectedRows.length') == @get('rows.length')
  ).property 'selectedRows.length'

  didInsertElement: ->
    @loadData()
    if typeof(@parentController.get 'tableBridge') != 'undefined'
      @parentController.set 'tableBridge', @

  loadData: ->
    store = @get('parentController').store
    @get('rows').clear()
    $.getJSON @get('url'), { limit: @get('limit'), page: @get('page') }
      .then (response)=>
        @set 'totalRows', response.total
        @set 'page', response.page
        @set 'limit', response.limit
        data = {}
        data[ response.data_type ] = response.data
        store.pushPayload response.data_type, data
        response.data.forEach (d)=>
          @get('rows').pushObject store.getById( response.data_type, d.id )

  actions:

    toggleAllRows: ->
      if @get('selectedRows.length') > 0
        @get('selectedRows').clear()
      else
        @get('rows').forEach (row)=>
          @get('selectedRows').pushObject row
        
    
Caminio.AdvancedTableRowItemController = Ember.ObjectController.extend

  selected: (->
    @get('parentController.selectedRows').findBy('id', @get('content.id'))
  ).property 'parentController.selectedRows.[]'

  actions:

    editRow: ->
      row = @get('content')
      @get('parentController.parentController').transitionToRoute 'ticketeer_venues.edit', row.get('id')

    selectRow: ->
      row = @get('content')
      if rowO = @get('parentController.selectedRows').findBy('id', row.get('id'))
        @get('parentController.selectedRows').removeObject rowO
      else
        @get('parentController.selectedRows').pushObject row

Caminio.AdvancedTableColumnItemController = Ember.ObjectController.extend

  cssClasses: (->
    column = @get('content')
    cssClasses = column.cssClasses || ""
    cssClasses += "adv-table-icon" if column.type == 'icon'
    cssClasses
  ).property ''

  value: (->
    column = @get('content')
    value = @get("parentController.content.#{column.name}")
    switch column.type
      when 'date'
        moment(value).fromNow()
      else
        value
  ).property 'parentController.content.updated_at'

Caminio.AdvancedTableHeaderItemController = Ember.ObjectController.extend

  getTitleTranslation: (->
    return Em.I18n.t( @get 'content.i18n' ) unless Em.isEmpty @get('content.i18n')
    return '' if Em.isEmpty @get('content.name')
    Em.I18n.t( @get 'content.name' )
  ).property ''