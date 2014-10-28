App.TableCheckboxView = Em.View.extend
  templateName: 'common/table_checkbox'

  oneSelected: (->
    @get('controller.selectedRows.length') > 0
  ).property 'controller.selectedRows.@each'

  allSelected: (->
    @get('controller.selectedRows.length') == @get('controller.content.length')
  ).property 'controller.selectedRows.@each'

