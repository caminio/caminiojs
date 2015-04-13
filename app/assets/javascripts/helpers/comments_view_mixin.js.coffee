Caminio.CommentsViewMixin = Ember.Mixin.create
  
  didInsertElement: ->
    @$('.comments-box textarea').autogrow()
    @_super()
