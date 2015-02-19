Caminio.AppBillEntry  = DS.Model.extend
  app_name:     DS.attr 'string'
  app_link:     DS.attr 'string'
  app_icon:     DS.attr 'string'
  name:         DS.attr 'string'
  # unique_name:  (->
  #   "#{@get('app_name')}-#{@get('name')}"
  # ).property 'app_name', 'name'
  total_value:  DS.attr 'number'
  tax_rate:     DS.attr 'number'

Caminio.AppBillEntryAdapter = Caminio.ApplicationAdapter.extend()