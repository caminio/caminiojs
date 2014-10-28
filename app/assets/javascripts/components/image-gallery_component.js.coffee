App.ImageGalleryComponent = Em.Component.extend

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

  actions:

    toggleEdit: ->
      @set('curEditingImg',null)
      $('.modal-title').text Em.I18n.t('image_gallery.title')

    save: ->
      comp = @
      @get('curEditingImg')
        .save()
        .then ->
          comp.set 'curEditingImg', null
        .catch (e)->
          console.log('error', e)

