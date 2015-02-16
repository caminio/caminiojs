Caminio.UsersEditController = Ember.ObjectController.extend
  needs: ['application','sessions']

  notyMessages: true
  oldRoleName: null
  oldLocale: null

  roleNameObserver: (->
    return unless @get('content.role_name')
    return if @get('content.role_name') == @get('oldRoleName')
    unless @get('oldRoleName')
      return @set('oldRoleName', @get('content.role_name'))
    return unless @get('controllers.application.currentUser.admin')
    @set('oldRoleName', @get('content.role_name'))
    @get('content')
      .save()
      .then =>
        noty
          type: 'success'
          text: Em.I18n.t('user.role_changed', name: @get('content.name'), role: Em.I18n.t("roles.#{@get('content.role_name')}") )
      .catch Caminio.NotyUnknownError
  ).observes 'content.role_name'

  localeObserver: (->
    return unless @get('content.locale')
    return if @get('content.locale') == @get('oldLocale')
    unless @get('oldLocale')
      return @set('oldLocale', @get('content.locale'))
    @set('oldLocale', @get('content.locale'))
    @get('content')
      .save()
      .then =>
        noty
          type: 'success'
          text: Em.I18n.t('user.locale_changed', locale: @get('content.locale') )
      .catch Caminio.NotyUnknownError
  ).observes 'content.locale'

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
      @get('content')
        .save()
        .then =>
          if callback
            return callback.call(scope)
          noty
            type: 'success'
            text: Em.I18n.t('saved', name: @get('content.name'))

    toggleSuspended: (user)->
      user = user || @get('content')
      if user.get('id') == @get('controllers.application.currentUser.id')
        return noty({ type: 'error', text: Em.I18n.t('errors.cannot_suspend_yourself') })
      unless user.get('suspended') # we are about to suspend a user. Double-check
        bootbox.confirm Em.I18n.t('user.really_suspend'), (result)=>
          return unless result
          @suspendNow( user )
      else
        @suspendNow( user )

    delete: ->

      if @get('content.id') == @get('controllers.application.currentUser.id')
        return noty({ type: 'error', text: Em.I18n.t('errors.please_remove_yourself_in_your_account_settings') })

      bootbox.prompt Em.I18n.t('user.really_delete', email: @get('content.email')), (result)=>
        if result != @get('content.email')
          return noty({ type: 'warning', text: Em.I18n.t('aborted')})
        @get('content')
          .destroyRecord()
          .then =>
            noty
              type: 'success'
              text: Em.I18n.t('user.has_been_deleted', name: @get('content.name'))
            @transitionToRoute 'users.index'
          .catch (err)->
            console.log 'error', err
            noty
              type: 'error'
              timeout: false
              text: Em.I18n.t('errors.unknown')