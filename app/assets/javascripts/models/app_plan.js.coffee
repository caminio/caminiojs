App.AppPlan = DS.Model.extend
  name:                 DS.attr 'string'
  app:                  DS.belongsTo 'app'
  translations:         DS.hasMany 'translation', embedded: 'always'
  user_quota:           DS.attr 'number'
  formattedUserQuota: (->
    if @get('user_quota') == 0
      return '&infin;'
    @get('user_quota')
  ).property 'user_quota'
  disk_quota:           DS.attr 'number'
  formattedDiskQuota:        (->
    if @get('disk_quota') == 0
      return '&infin;'
    filesize @get('disk_quota')*1000*1000 || 0, base: 2, round: 0
  ).property 'disk_quota'
  content_quota:        DS.attr 'number'
  price:                DS.attr 'number'
  formattedPrice:       (->
    accounting.formatMoney(  (@get('price')/100.0 || 0), "EUR ", 2, " ", ",")  
  ).property 'price'
  organizational_unit:  DS.belongsTo 'organizational_unit'
  usersQuotaWidth: (->
    "width: #{(@get('organizational_unit.users.length')/100*@get('user_quota'))}%"
  ).property 'user_quota', 'organizational_unit.users.length'
