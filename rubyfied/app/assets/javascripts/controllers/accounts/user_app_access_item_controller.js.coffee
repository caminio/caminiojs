App.UserAppAccessItemController = Em.ObjectController.extend

  appAccessColor: (->
    user = @get('parentController.content')
    access_rule = user.get('user_access_rules').findBy('app', @get('content.app'))
    return 'btn-pale' unless access_rule
    return 'btn-danger' if access_rule.get('can_delete')
    return 'btn-black' if access_rule.get('can_write')
  ).property 'parentController.content.user_access_rules.@each'

  actions:
    toggleAppAccess: (user, app)->
      console.log 'can share', App.get('currentUser').canShare(app)
      return unless App.get('currentUser').canShare(app)
      console.log 'is owner no', user.get('isOwner')
      return if user.get('isOwner')
      return if user == App.get('currentUser')
      if access_rule = user.get('user_access_rules').findBy('app', app)
        if access_rule.get('can_delete')
          access_rule.destroyRecord()
            .then ->
              toastr.info(Em.I18n.t('accounts.user.access.none', user_name: user.get('name'), app_name: app.get('name')))
              user.reload()
        else if access_rule.get('can_write')
          access_rule.set('can_delete',true)
          access_rule.set('can_write',true)
          access_rule.set('can_share',true)
          access_rule.save()
            .then ->
              toastr.info(Em.I18n.t('accounts.user.access.delete', user_name: user.get('name'), app_name: app.get('name')))
              user.reload()
        else
          access_rule.set('can_write',true)
          access_rule.save()
            .then ->
              toastr.info(Em.I18n.t('accounts.user.access.write', user_name: user.get('name'), app_name: app.get('name')))
              user.reload()
      else
        access_rule = @store.createRecord('user_access_rule', app: app, user: user, can_read: false, can_write: false, can_delete: false, organizational_unit: App.get('currentOu'))
        access_rule.save()
          .then ->
            toastr.info(Em.I18n.t('accounts.user.access.read', user_name: user.get('name'), app_name: app.get('name')))
            user.reload()

