App.ImageGalleryItemController = Em.ObjectController.extend
  actions:

    edit: ->
      img = @get('content')
      imgHtml = "<img src=\"#{location.protocol}//#{location.host}#{@get('content.file_original')}\">"
      @get('parentController').set('curEditingImg', img)
      $('.modal-title').text(img.get('file_file_name'))
      $(imgHtml).load ->
        img.set('width', @width)
        img.set('height', @height)

    remove: ->
      img = @get('content')
      bootbox.confirm Em.I18n.t('really_delete', img.get('file_file_name')), (result)->
        return unless result
        img
          .destroyRecord()
          .then ->
            toastr.success( Em.I18n.t('deleted', img.get('file_file_name')) )

    insert: ->
      # return if ($(e.target).closest('.btn').length || $(e.target).hasClass('btn'))
      imgHtml = "<img src=\"#{location.protocol}//#{location.host}#{@get('content.file_original')}\">"
      editor = @get('parentController.editor')
      $(imgHtml).load ->
        $imgHtml = $(imgHtml)
        if @width > 300
          $imgHtml.css('width', 300)
        console.log $imgHtml, $imgHtml.get(0).outerHTML
        editor.insertHtml $imgHtml.get(0).outerHTML
        $('.modal .close').click()
