App.ImageGalleryView = Em.View.extend

  didInsertElement: ->
    view = @
    $('#image-gallery-upload').fileupload
      url: '/caminio/mediafiles'
      paramName: 'file'
      formData:
        parent_id: @get('content.id')
        parent_type: @get('content.constructor.typeKey')
      dataType: 'json'
      done: (e, data)->
        view.get('content').reload()

    comp = @
    $('.image-gallery-item').on 'click', (e)->
      if $(@).hasClass('selected')
        return $(@).removeClass('selected')
      $('.image-gallery .image-gallery-item').removeClass('selected')
      $(@).addClass('selected')
      comp.set('curImageUrl', "#{location.protocol}//#{location.host}#{$(@).attr('data-url')}")
