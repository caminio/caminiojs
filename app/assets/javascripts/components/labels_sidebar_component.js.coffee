App.LabelsSidebarComponent = Em.Component.extend

  actions:

    newLabel: ->
      @set('label', @get('parentController').store.createRecord('label', category: @get('category') ))
      @get('parentController').send('openModal', 'labels/edit', @)

    editLabel: (label)->
      @set('label',label)
      @get('parentController').send('openModal', 'labels/edit', @)

    toggleLabel: (label)->
      @get('parentController').send('toggleLabel', label)

    searchLabel: (label)->
      @get('parentController').send('searchLabel', label)

    deleteLabel: ->
      comp = @
      bootbox.confirm Em.I18n.t('really_delete', name: @get('label.name')), (result)->
        return unless result
        comp.get('label')
          .destroyRecord()
          .then ->
            toastr.success Em.I18n.t('label.deleted', name: comp.get('label.name'))
            $('.modal .close').click()
          .catch (err)->
            console.error err.responseJSON
            toastr.error Em.I18n.t('label.deletion_failed', name: comp.get('label.name'))

    saveLabel: ->
      comp = @
      wasNew = @get('label.isNew')
      @get('label')
        .save()
        .then (label)->
          $('.modal .close').click()
          comp.get('parentController').send('closeModal')
          toastr.success Em.I18n.t('label.saved', name: label.get('name'))
          comp.get('labels').pushObject(label) if wasNew

    closeModal: ->
      $('.modal .close').click()
      @get('parentController').send('closeModal')

App.LabelsSidebarLabelItemController = Em.ObjectController.extend

  isActive: ( ->
    @get('parentController.parentController.selected_labels').findBy('id', @get('content.id'))
  ).property 'parentController.parentController.selected_labels.[]'

