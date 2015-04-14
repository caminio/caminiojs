Caminio.AsideCommentsComponent = Ember.Component.extend Caminio.CardNavTabsMixin,
  
  tagName: 'aside'
  classNames: ['card']

  didInsertElement: ->
    @$('.comments-form-wrap textarea').autogrow()
    @_super()

  newComment: false
  curComment: null

  actions:

    toggleNewComment: ->
      @toggleProperty 'newComment'
      if @get('newComment')
        parent = @get('targetObject.content')
        @set 'curComment', @get('targetObject').store.createRecord('comment', 
          commentable_type: parent.get('constructor.typeKey'),
          commentable_id: parent.get('id')
          )
        console.log 'added comment', @get('curComment.commentable_type')
        Em.run.later =>
          @$('.comments-form-wrap textarea').focus()
        , 100

    saveCurComment: ->
      @get('curComment')
        .save()
        .then (comment)->
          parent = @get('targetObject.content')
          parent.get('comments').pushObject comment
          noty
            text: Em.I18n.t('comment.saved')
            type: 'success'
        .catch (err)->
          Caminio.NotyUnknownError(err)