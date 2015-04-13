Caminio.AsideCommentsComponent = Ember.Component.extend
  
  didInsertElement: ->
    @$('.comments-box textarea').autogrow()
    @_super()

  addComment: false
