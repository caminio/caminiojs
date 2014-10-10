App.ImageGalleryView = Em.View.extend

  didInsertElement: ->
    view = @
    content = @get('controller.content')
    controller = @get('controller')

    $('#image-gallery-upload').fileupload
      url: '/caminio/mediafiles'
      paramName: 'file'
      formData:
        parent_id: content.get('id')
        parent_type: content.get('constructor.typeKey')
      dataType: 'json'
      progressall: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10)
        view.$('.progress-bar').css('width', progress + '%' )
      done: (e, data)->
        content.reload()
    .on('fileuploadstart', ->
      view.$('.progress-bar').css('width',0).show()
      view.$('.bitrate').show()
    ).on('fileuploadstop', ->
      view.$('.progress-bar').fadeOut()
      view.$('.bitrate').fadeOut()
    ).on('fileuploadprogress', (e,data)->
      view.$('.bitrate').text(filesize(data.bitrate, bits: true)+'/s')
    )

    $('.image-gallery-item').on 'click', (e)->
      imgHtml = "<img src=\"#{location.protocol}//#{location.host}#{$(@).attr('data-url')}\">"
      controller.get('editor').insertHtml imgHtml
      $('.modal .close').click()
