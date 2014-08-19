App.EmberTableActionView = Ember.View.extend
  tagName: 'a'
  click: (e)->
    content = @_parentView._parentView.get('row.content')
    controller = @nearestWithProperty('hasHeader')._parentView.controller
    controller.send(@get('actionName'), content)

App.EmberTableCheckboxView = Ember.View.extend
  layoutName: 'common/ember-table/checkbox'

App.EmberTableCheckboxCheckView = Ember.View.extend
  tagName: 'span'
  classNames: 'fa fa-check'
  classNameBindings: ['isSelected::hide','allSelected:all-selected']
  isSelected: (->
    selectedRecords = @get('parentView.parentView.controller.selectedRecords')
    if @get('parentView.parentView.isHeaderCell')
      return selectedRecords.get('length') > 0
    selectedRecords.findBy( 'id', @get('parentView.parentView.row.content.id') )
  ).property 'parentView.parentView.controller.selectedRecords.@each'
  allSelected: (->
    @get('controller.selectedRecords.length') == @get('controller.content.length')
  ).property 'parentView.parentView.controller.selectedRecords.length'

App.EmberTableCheckboxHeaderInfoView = Ember.View.extend
  tagName: 'li'
  classNames: 'header-actions-title'
  classNameBindings: ['hasSelection::hide']
  template: Ember.Handlebars.compile "{{t 'action_for'}} {{controller.selectedRecords.length}} {{t 'records'}}"
  hasSelection: (->
    return false unless @get('parentView.parentView.isHeaderCell')
    @get('parentView.parentView.controller.selectedRecords.length') > 0
  ).property 'parentView.parentView.controller.selectedRecords.length'

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
    )

Ember.Table.EmberTableComponent.reopen
  selectedRecords: Em.A()

Ember.Table.CheckboxCell = Ember.Table.TableCell.extend
  classNames: 'ember-table-row-checkbox'
  didInsertElement: fixDropdown
  click: (e)->
    return unless ($(e.target).closest('.row-checkbox').length || $(e.target).hasClass('.row-checkbox'))
    record = @get('row.content')
    selectedRecords = @get('controller.selectedRecords')
    if selectedRecords.findBy('id', record.id)
      return selectedRecords.removeObject(record)
    selectedRecords.pushObject record

Ember.Table.CheckboxHeaderCell = Ember.Table.HeaderCell.extend
  classNames: 'ember-table-row-checkbox ember-table-header-row-checkbox'
  isHeaderCell: true
  didInsertElement: fixDropdown
  click: (e)->
    return unless ($(e.target).closest('.row-checkbox').length || $(e.target).hasClass('.row-checkbox'))
    selectedRecords = @get('controller.selectedRecords')
    if @get('controller.selectedRecords.length') > 0
      return selectedRecords.clear()
    @get('controller.content').forEach (record)->
      selectedRecords.pushObject record

      
