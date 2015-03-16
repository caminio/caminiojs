Caminio.UsersEditController = Ember.ObjectController.extend

  needs: ['application','sessions']

  user: null

  old_password: ''
  new_password: ''
  confirm_new_password: ''

  notyMessages: true

  isCurrent: (->
    @get('user.id') == @get('controllers.application.currentUser.id')
  ).property 'user'

  isNotCurrent: (->
    @get('user.id') != @get('controllers.application.currentUser.id')
  ).property 'user'

  isAdminNotCurrent: (->
    return false unless @get('controllers.application.currentUser.admin')
    @get('isNotCurrent')
  ).property 'user'

  suspendNow: (user)->
    user.toggleProperty('suspended')
    user
      .save()
      .then ->
        msg = if user.get('suspended') then Em.I18n.t('user.has_been_suspended') else Em.I18n.t('user.back_active')
        noty
          type: 'success'
          text: msg
      .catch Caminio.NotyUnknownError

  actions:

    save: (callback, scope)->
      @get('user')
        .save()
        .then =>
          if callback
            return callback.call(scope)
          noty
            type: 'success'
            text: Em.I18n.t('saved', name: @get('user.name'))

    toggleSuspended: (user)->
      user = user || @get('user')
      if user.get('id') == @get('controllers.application.currentUser.id')
        return noty({ type: 'error', text: Em.I18n.t('errors.cannot_suspend_yourself') })
      unless user.get('suspended') # we are about to suspend a user. Double-check
        bootbox.confirm Em.I18n.t('user.really_suspend'), (result)=>
          return unless result
          @suspendNow( user )
      else
        @suspendNow( user )

    change_password: ->
      return if Em.isEmpty @get('new_password')
      if @get('new_password') != @get('confirm_new_password')
        return noty({ text: Em.I18n.t('user.passwords_missmatch'), type: 'error' })
      $.ajax 
        url: "#{Caminio.get('apiHost')}/users/change_password"
        type: 'post'
        data:
          old: @get('old_password')
          new: @get('new_password')
          user_id: @get('user.id')
      .then =>
        noty { text: Em.I18n.t('user.password_changed'), type: 'success' }
        @set 'old_password', ''
        @set 'new_password', ''
        @set 'confirm_new_password', ''
        @send 'closeMiniModal'
      .fail (e)->
        if e.status == 403
          noty { text: Em.I18n.t('user.old_password_missmatch'), type: 'error' }
        else
          Caminio.NotyUnknownError()

    delete: ->

      if @get('user.id') == @get('controllers.application.currentUser.id')
        return noty({ type: 'error', text: Em.I18n.t('errors.please_remove_yourself_in_your_account_settings') })

      bootbox.prompt Em.I18n.t('user.really_delete', email: @get('user.email')), (result)=>
        if result != @get('user.email')
          return noty({ type: 'warning', text: Em.I18n.t('aborted')})
        @get('user')
          .destroyRecord()
          .then =>
            noty
              type: 'success'
              text: Em.I18n.t('user.has_been_deleted', name: @get('user.name'))
            @transitionToRoute 'users.index'
          .catch (err)->
            console.log 'error', err
            noty
              type: 'error'
              timeout: false
              text: Em.I18n.t('errors.unknown')