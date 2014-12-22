App.AccountsApiController = Em.ArrayController.extend
  auth: true

  actions:

    new: ->
      controller = @
      Em.$.ajax
        url: '/caminio/api_keys'
        type: 'post'
      .then (api_key)->
        controller.set('content', controller.store.find('api_key', permanent: true))
      .fail (err)->
        console.log(err)

    save: (api_key)->
      api_key
        .save()
        .then ->
          $('.modal .close').click()
          toastr.success Em.I18n.t('accounts.api.saved', name: api_key.get('name'))
        .catch (err)->
          toastr.error Em.I18n.t('accounts.api.saving_failed', name: api_key.get('name'))
          console.log 'error', err

    delete: (api_key)->
      bootbox.confirm Em.I18n.t('accounts.api.really_delete', name: api_key.get('name')), (result)->
        return unless result
        api_key
          .destroyRecord()
          .then ->
            $('.modal .close').click()
            toastr.success Em.I18n.t('accounts.api.deleted', name: api_key.get('name'))
          .catch (err)->
            toastr.error Em.I18n.t('accounts.api.deletion_failed', name: api_key.get('name'))
            console.log 'error', err

