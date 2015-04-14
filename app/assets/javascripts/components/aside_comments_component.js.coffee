Caminio.AsideCommentsComponent = Ember.Component.extend Caminio.CardNavTabsMixin,
  
  tagName: 'aside'
  classNames: ['card']

  didInsertElement: ->
    @$('.comments-form-wrap textarea').autogrow()
    @_super()

  newComment: false
  curComment: null

  comments: (->
    @get('targetObject.content.comments')
  ).property 'targetObject.content.comments.@each'

  actions:

    toggleNewComment: ->
      @toggleProperty 'newComment'
      if @get('newComment')
        parent = @get('targetObject.content')
        @set 'curComment', @get('targetObject').store.createRecord('comment', 
          commentable_type: parent.get('constructor.typeKey'),
          commentable_id: parent.get('id')
          )
        Em.run.later =>
          @$('.comments-form-wrap textarea').focus()
        , 100
      else
        @set 'curComment', null

    saveCurComment: ->
      parent = @get('targetObject.content')
      @get('curComment')
        .save()
        .then (comment)->
          parent.reload()
          noty
            text: Em.I18n.t('comment.saved')
            type: 'success'
        .catch (err)->
          console.log 'error', err
          Caminio.NotyUnknownError(err)