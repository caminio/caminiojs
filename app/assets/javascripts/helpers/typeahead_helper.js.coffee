###
 Typeahead helper

  example:

    {{view typeahead
            class="form-control"
            source="/caminio/users?simple_list=1&q=%QUERY"
            optionValuePath="email"
            valueBinding="ownerEmail"}}
###

Caminio.TypeaheadView = Ember.TextField.extend

  classNames: ['input-xlarge']

  didInsertElement: ->
    Ember.run.scheduleOnce('afterRender', this, 'processChildElements')

  processChildElements: ->
    sources = null
    if( this.get('source') )
      sources = new Bloodhound
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace( @get('optionValuePath') )
        queryTokenizer: Bloodhound.tokenizers.whitespace
        remote: "#{Caminio.get('apiHost')}#{@get('source')}"

    else if( @get('localContent') )
      sources = new Bloodhound
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace( @get('optionValuePath'))
        queryTokenizer: Bloodhound.tokenizers.whitespace
        local: $.map( @get('localContent'), (c)-> return { value: c } )

    if( !sources )
      return;

    sources.initialize()

    @$().typeahead null,
      displayKey: @get('optionValuePath')
      restrictInputToDatum: true
      source: sources.ttAdapter()
      templates:
        empty: [
          '<div class="empty-message">',
          Em.I18n.t('no_matches_found'),
          '</div>'
          ].join('\n')
        suggestion: Handlebars.compile('<p><strong>{{name}}</strong> – {{email}}</p>')

  willDestroyElement: ->
    @$().typeahead('destroy')