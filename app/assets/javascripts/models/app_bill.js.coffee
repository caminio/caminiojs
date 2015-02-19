Caminio.AppBill  = DS.Model.extend
  app_bill_entries:     DS.hasMany 'app_bill_entries'
  currency:             DS.attr 'string', defaultValue: 'EUR'
  paid_at:              DS.attr 'date'
  created_at:           DS.attr 'date', defaultValue: (-> new Date())

Caminio.AppBillAdapter = Caminio.ApplicationAdapter.extend()