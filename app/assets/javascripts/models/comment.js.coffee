Caminio.Comment = DS.Model.extend
  title:            DS.attr 'string'
  content:          DS.attr 'string'
  
  commentable_type: DS.attr 'string'
  commentable_id:   DS.attr 'string'

  created_at:                     DS.attr 'date'
  created_by:                     DS.belongsTo 'user'
  updated_by:                     DS.belongsTo 'user'
  updated_at:                     DS.attr 'date'

  formattedContent: (->
    @get('content').replace(/\n/g,'<br>')
  ).property 'content'