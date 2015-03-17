Caminio.AdvancedTableComponent = Ember.Component.extend

  cachedData: undefined
  filter: null
  url: null
  limit: 30
  page: 0
  totalRows: 0
  columns: Em.A()
  rows: null
  isInlineEditable: false

  selectedRows: Em.A()

  someRowsSelected: (->
    @get('selectedRows.length') > 0
  ).property 'selectedRows.length'

  allRowsSelected: (->
    @get('selectedRows.length') == @get('rows.length')
  ).property 'selectedRows.length'

  didInsertElement: ->
    @set 'rows', Em.A()
    @loadData()
    if typeof(@get('targetObject.tableBridge')) != 'undefined'
      @get('targetObject').set 'tableBridge', @

  loadData: ->
    @get('rows').clear()
    return @loadCachedData() if @get('cachedData')
    store = @get('targetObject.store')
    $.getJSON @get('url'), { limit: @get('limit'), page: @get('page') }
      .then (response)=>
        @set 'totalRows', response.total
        @set 'page', response.page
        @set 'limit', response.limit
        data = {}
        data[ response.data_type ] = response.data
        store.pushPayload response.data_type, data
        response.data.forEach (d)=>
          @set 'cachedDataType', response.data_type
          @get('rows').pushObject store.getById( response.data_type, d.id )

  loadCachedData: ->
    cachedDataType = @get('cachedDataType')
    store = @get('targetObject.store')
    @get('cachedData').forEach (d)=>
      @get('rows').pushObject store.getById( cachedDataType, d.id )
    @set 'totalRows', @get('rows.length')

  actions:

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

Caminio.AdvancedTableColumnItemController = Ember.ObjectController.extend

  cssClasses: (->
    column = @get('content')
    cssClasses = column.cssClasses || ""
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