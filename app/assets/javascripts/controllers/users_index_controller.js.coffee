Caminio.UsersIndexController = Ember.ArrayController.extend

  sortProperties: ['name']
  sortAscending: true

  filter: ''

  filteredContent: (->
    filter = @get('filter');
    return @get('arrangedContent') if Em.isEmpty(filter)
    rx = new RegExp(filter, 'gi');
    this.get('arrangedContent')
      .filter (content)->
        content.get('name').match(rx) || content.get('email').match(rx)
  ).property 'arrangedContent', 'filter'

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

    editUser: (user)->
      @transitionToRoute('users.edit',user)

    clearFilter: ->
      @set('filter','')