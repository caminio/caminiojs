App.Mediafile = DS.Model.extend
  file_file_name:   DS.attr('string')
  file_content_type: DS.attr('string')
  file_file_size: DS.attr('string')
  parent_id: DS.attr('string')
  parent_type: DS.attr('string')
  file_thumb: DS.attr('string')
  file_original: DS.attr('string')
  copyright: DS.attr('string')
  description: DS.attr('string')
  humanFileSize: Em.computed ->
    filesize( @get('file_file_size') )
