Caminio.Comment = DS.Model.extend
  title:            DS.attr 'string'
  content:          DS.attr 'string'
  commentable_type: DS.attr 'string'
  commentable_id:   DS.attr 'string'