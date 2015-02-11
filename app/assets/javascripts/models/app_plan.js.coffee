Caminio.AppPlan  = DS.Model.extend
  app_name:             DS.attr 'string'
  price:                DS.attr 'number'
  currency:             DS.attr 'string', defaultValue: 'EUR'
  subscription_ends_at: DS.attr 'date'