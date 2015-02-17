Caminio.GroupsIndexController = Ember.ArrayController.extend

  needs: ['application']
  
  sortProperties: ['name']
  sortAscending: true

  loadingUsers: true

  filter: ''

  filteredContent: (->
    filter = @get('filter');
    return @get('arrangedContent') if Em.isEmpty(filter)
    rx = new RegExp(filter, 'gi');
    this.get('arrangedContent')
      .filter (content)->
        content.get('name').match(rx) || content.get('email').match(rx)
  ).property 'arrangedContent', 'filter'

  actions:

    clearFilter: ->
      @set('filter','')