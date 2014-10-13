App.UserAppAccessItemController = Em.ObjectController.extend

  appAccessColor: (->
    console.log 'app access here'
    return 'btn-danger' if @get('content.can_delete')
    return 'btn-success' if @get('content.can_write')
  ).property 'content.can_write', 'content.can_share', 'content.can_delete'

  actions:
    toggleAppAccess: (user, app)->
      if access_rule = user.get('access_rules').findBy('app', app)
        if access_rule.get('can_delete')
          access_rule.destroyRecord().then -> toastr.info(Em.I18n.t('accounts.user.access.none', user_name: user.get('name'), app_name: app.get('name')))
        else if access_rule.get('can_write')
          access_rule.set('can_delete',true)
          access_rule.set('can_write',true)
          access_rule.set('can_share',true)
          access_rule.save().then -> toastr.info(Em.I18n.t('accounts.user.access.delete', user_name: user.get('name'), app_name: app.get('name')))
        else
          access_rule.set('can_write',true)
          access_rule.save().then -> toastr.info(Em.I18n.t('accounts.user.access.write', user_name: user.get('name'), app_name: app.get('name')))
      else
        access_rule = @store.createRecord('access_rule', app: app, user: user, can_read: false, can_write: false, can_delete: false)
        access_rule.save().then -> toastr.info(Em.I18n.t('accounts.user.access.read', user_name: user.get('name'), app_name: app.get('name')))

