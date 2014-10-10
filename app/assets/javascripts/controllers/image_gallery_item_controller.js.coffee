App.ImageGalleryItemController = Em.ObjectController.extend
  actions:

    remove: ->
      img = @get('content')
      bootbox.confirm Em.I18n.t('image_gallery.really_remove', img.get('name')), (result)->
        return unless result
        img
          .destroyRecord()
          .then ->
            toastr.success( Em.I18n.t('image_gallery.removed', img.get('name')) )
