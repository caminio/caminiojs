Caminio.AdvancedTableComponent = Ember.Component.extend

  cachedData: undefined
  cachedDataType: undefined
  filter: null
  url: null
  limit: 30
  page: 0
  totalRows: 0
  columns: Em.A()
  rows: null
  isInlineEditable: false
  deleteRowAction: 'deleteRow'
  footer: null
  order: null
  orderAsc: true

  selectedRows: Em.A()

  someRowsSelected: (->
    @get('selectedRows.length') > 0
  ).property 'selectedRows.length'

  allRowsSelected: (->
    @get('selectedRows.length') == @get('rows.length')
  ).property 'selectedRows.length'

  reload: ->
    @set 'rows', Em.A()
    @loadData()

  didInsertElement: ->
    @set 'rows', Em.A()
    @loadData()
    if typeof(@get('targetObject.tableBridge')) != 'undefined'
      @get('targetObject').set 'tableBridge', @

    @$().on 'click', 'button[data-toggle=dropdown]', (e)->
      $(@).dropdown('toggle')
      e.stopPropagation()

    @$().on 'click', '.dropdown-menu', (e)->
      $(this).parent().find('.dropdown-toggle').dropdown('toggle')

  loadData: ->
    @get('rows').clear()
    return @loadCachedData() if @get('cachedData')
    store = @get('targetObject.store')
    $.getJSON @get('url'), { limit: @get('limit'), page: @get('page'), order_by: (@get('order') || 'created_at'), order_asc: @get('orderAsc'), filter: @get('filter') }
      .then (response)=>
        @set 'totalRows', response.total
        @set 'page', response.page
        @set 'limit', response.limit
        data = {}
        data[ response.data_type ] = response.data
        if response.data_type
          store.pushPayload response.data_type, data
        @set 'cachedDataType', response.data_type
        response.data.forEach (d)=>
          if response.data_type
            @get('rows').pushObject store.getById( response.data_type, d.id )
          else
            @get('rows').pushObject Em.Object.create(d)

  loadCachedData: ->
    cachedDataType = @get('cachedDataType')
    store = @get('targetObject.store')
    @get('cachedData').forEach (d)=>
      @get('rows').pushObject store.getById( cachedDataType, d.id )
    @set 'totalRows', @get('rows.length')

  lastFilterAction: null
  filter: null

  filterObserver: (->
    @set 'filter', @get('targetObject.filter')
    @set('filter', null) if Em.isEmpty( @get('filter') )
    @set('lastFilterAction', new Date())
    Em.run.later =>
      if @get('lastFilterAction') < (new Date()) - 2000
        @loadData()
    , 2010
  ).observes 'targetObject.filter'

  actions:

    search: (filter)->
      console.log 'searching for ', filter

    toggleAllRows: ->
      if @get('selectedRows.length') > 0
        @get('selectedRows').clear()
      else
        @get('rows').forEach (row)=>
          @get('selectedRows').pushObject row

    addRow: ->
      defaults = @get('newDataDefaults') || {}
      row = @get('targetObject.store').createRecord( @get('cachedDataType'), defaults )
      row.set 'isEditing', true
      @get('rows').unshiftObject row
      @set 'totalRows', @get('totalRows')+1
        
    
Caminio.AdvancedTableRowItemController = Ember.ObjectController.extend

  selected: (->
    @get('parentController.selectedRows').findBy('id', @get('content.id'))
  ).property 'parentController.selectedRows.[]'

  rowEditingObserver: (->
    row = @get('content')
    return unless row.get('isEditing')
    @get('parentController.rows')
      .filterBy('isEditing',true)
      .forEach (r)->
        r.set('isEditing',false) if r.id != row.id
  ).observes 'content.isEditing'

  actions:

    editRow: ->
      row = @get('content')
      if @get('parentController.isInlineEditable') 
        return if row.get('isEditing')
        row.set 'isEditing', true
        return
      @get('parentController.targetObject').transitionToRoute @get('parentController.editRouteName'), row.get('id')

    deleteRow: ->
      row = @get('content')
      @get('parentController.rows').removeObject(row)
      @get('parentController.targetObject').send @get('parentController.deleteRowAction'), row

    cancelEdit: ->
      row = @get('content')
      row.set 'isEditing', false

    saveRow: ->
      row = @get('content')
      row
        .save()
        .then ->
          row.set 'isEditing', false

    selectRow: ->
      row = @get('content')
      if rowO = @get('parentController.selectedRows').findBy('id', row.get('id'))
        @get('parentController.selectedRows').removeObject rowO
      else
        @get('parentController.selectedRows').pushObject row

    sendControllerAction: (actionName)->
      @get('parentController.targetObject').send actionName, @get('content')
      return

Caminio.AdvancedTableColumnItemController = Ember.ObjectController.extend

  cssClasses: (->
    column = @get('content')
    cssClasses = column.cssClasses || ""
    cssClasses += " " unless Em.isEmpty(cssClasses)
    cssClasses += "nicedate-cell" if column.type == 'niceDate'
    cssClasses += "align-right" if column.align && column.align == 'right'
    cssClasses += "adv-table-icon" if column.type == 'icon'
    cssClasses
  ).property ''

  cssStyles: (->
    column = @get('content')
    styles = ''
    styles += "width: #{column.width}" unless Em.isEmpty(column.width)
    styles
  ).property ''

  value: (->
    column = @get('content')
    value = @get("parentController.content.#{column.name}")
    switch column.type
      when 'date'
        moment(value).fromNow()
      when 'currency'
        accounting.formatMoney value
      when 'niceDate'
        "<div class=\"daybox\"><div class=\"daynum\"> #{moment(value).format('DD')} </div>
          <div class=\"month\"> #{moment(value).format('MMMM')} </div>
         </div>
         <div class=\"full-date\">
          <span class=\"desc\"> #{moment(value).format('YYYY')} </span>&nbsp;&nbsp;
          #{moment(value).format('dddd, HH:mm')}
         </div>"
      else
        value
  ).property 'parentController.content.updated_at'

  editValue: ( (key,val)->
    column = @get('content')
    if val
      @get('parentController.content').set column.name, val
    value = @get("parentController.content.#{column.name}")
    switch column.type
      when 'date'
        moment(value).fromNow()
      else
        value
  ).property 'parentController.content.updated_at'

Caminio.AdvancedTableHeaderItemController = Ember.ObjectController.extend

  cssHeaderClasses: (->
    column = @get('content')
    cssClasses = column.cssHeaderClasses || ""
    cssClasses += "nicedate-cell" if column.type == 'niceDate'
    cssClasses += "align-right" if column.align && column.align == 'right'
    cssClasses
  ).property ''

  cssHeaderStyles: (->
    column = @get('content')
    styles = ''
    styles += "width: #{column.width}" unless Em.isEmpty(column.width)
    styles
  ).property ''

  getTitleTranslation: (->
    return Em.I18n.t( @get 'content.i18n' ) unless Em.isEmpty @get('content.i18n')
    return '' if Em.isEmpty @get('content.name')
    Em.I18n.t( @get 'content.name' )
  ).property ''

Caminio.AdvancedTableFooterItemController = Ember.ObjectController.extend

  cssHeaderClasses: (->
    index = @get('parentController.footer').indexOf( @get('content') )
    column = @get('parentController.columns')[index]
    cssClasses = column.cssHeaderClasses || ""
    cssClasses += "align-right" if column.align && column.align == 'right'
    cssClasses
  ).property ''
  
  calculatedValue: (->
    return '' unless @get('content.type') == 'sum'
    index = @get('parentController.footer').indexOf( @get('content') )
    column = @get('parentController.columns')[index]
    result = 0
    return unless @get('parentController.rows')
    @get('parentController.rows').forEach (row)->
      result += row.get( column['name'] )
    result
  ).property 'parentController.rows.@each'