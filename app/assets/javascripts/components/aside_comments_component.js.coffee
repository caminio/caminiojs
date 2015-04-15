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

  content: (->
    @get('targetObject.content')
  ).property 'targetObject.content'

  updatedDiffersCreated: (->
    moment(@get('targetObject.content.created_at')).format('LLL') != moment(@get('targetObject.content.updated_at')).format('LLL')
  ).property 'targetObject.content.updated_at'

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
        .then (comment)=>
          parent.reload()
          @set 'curComment', @get('targetObject').store.createRecord('comment', 
            commentable_type: parent.get('constructor.typeKey'),
            commentable_id: parent.get('id')
            )
          noty
            text: Em.I18n.t('comment.saved')
            type: 'success'
        .catch (err)->
          console.log 'error', err
          Caminio.NotyUnknownError(err)

Caminio.CommentItemController = Ember.ObjectController.extend

  actions:

    delete: ->
      comment = @get('content')
      content = @get('parentController.content')
      $.ajax
        url: "/api/v1/comments/#{comment.get('id')}/#{comment.get('commentable_type')}/#{comment.get('commentable_id')}"
        type: 'delete'
      .then ->
        noty
          text: Em.I18n.t('comment.deleted')
          type: 'success'
        content.reload()