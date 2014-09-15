App.TableRowItemView = Em.View.extend
  template: Ember.Handlebars.compile "{{view.value}}"
  value: (->
    row = @get 'row'
    cell = row.get('contact_contact_fields').findBy( 'contact_field', @get('contactTemplateField.contact_field') )
    return cell.get 'value' if cell
    ''
  ).property 'parentView.row', 'contactTemplateField'

