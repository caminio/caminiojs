App.OrganizationalUnit = DS.Model.extend
  name:               DS.attr "string"
  fqdn:               DS.attr 'string'
  # users:              DS.hasMany "user", async: true
  owner:              DS.belongsTo 'user'
  app_plans:          DS.hasMany "app_plan"
  invoices:           DS.hasMany "invoice"
  settings:           DS.attr "object", defaultValue: { default_lang: LANG }
