Caminio.AppPlanItemController = Ember.ObjectController.extend
  
  price: (->
    price = accounting.formatMoney( parseInt(@get('content.price')) / 100 )
    "#{price} <small>/ #{Em.I18n.t('month')}</small>"
  ).property ''

  price_year: (->
    return '&nbsp;' unless @get('content.price_year')
    price = accounting.formatMoney( parseInt(@get('content.price_year')) / 100 )
    "<small>#{Em.I18n.t('or')} #{price} / #{Em.I18n.t('year')}</small>"
  ).property ''

  col: (->
    divider = 12 / @get('parentController.availablePlans.length')
    divider = 3 if divider < 3
    "col-md-#{divider}"
  ).property 'parentController.availablePlans.length'

