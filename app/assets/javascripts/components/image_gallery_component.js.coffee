App.ImageGalleryComponent = Em.Component.extend

  didInsertElement: ->
    $('#image-gallery-upload').fileupload
      url: '/caminio/mediafiles'
      paramName: 'file'
      formData:
        parent_id: @get('parent.id')
        parent_type: @get('parent.constructor.typeKey')
      dataType: 'json'
      done: (e, data)->
        console.log "DONE", data

    comp = @
    $('.image-gallery-item').on 'click', (e)->
      if $(@).hasClass('selected')
        return $(@).removeClass('selected')
      $('.image-gallery .image-gallery-item').removeClass('selected')
      $(@).addClass('selected')
      comp.set('curImageUrl', "#{location.protocol}//#{location.host}#{$(@).attr('data-url')}")
