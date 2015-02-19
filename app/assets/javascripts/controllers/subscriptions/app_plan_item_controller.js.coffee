Caminio.AppPlanItemController = Ember.ObjectController.extend
  
  price: (->
    price = accounting.formatMoney( parseInt(@get('content.total_value')) / 100 )
    "#{price} <small>/ #{Em.I18n.t('month')}</small>"
  ).property ''

  price_year: (->
    return '&nbsp;' unless @get('content.total_value_year')
    price = accounting.formatMoney( parseInt(@get('content.total_value_year')) / 100 )
    "<small>#{Em.I18n.t('or')} #{price} / #{Em.I18n.t('year')}</small>"
  ).property ''

  isCurrent: (->
    @get('parentController.selectedPlans').findBy('unique_name', @get('content.unique_name'))
  ).property 'parentController.selectedPlans.@each'
