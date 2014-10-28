Ember.ColorSelector = Em.View.extend

  templateName: 'common/ember_color_selector'

  colors: Em.A([
    Em.Object.create { color: "#FFFFFF", value: 1, label: Em.I18n.t('colors.sienna') }
    Em.Object.create { color: "#A0522D", value: 12, label: Em.I18n.t('colors.sienna') }
    Em.Object.create { color: "#CD5C5C", value: 13, label: Em.I18n.t('colors.indianred') }
    Em.Object.create { color: "#FF4500", value: 14, label: Em.I18n.t('colors.orangered') }
    Em.Object.create { color: "#008B8B", value: 15, label: Em.I18n.t('colors.darkcyan') }
    Em.Object.create { color: "#B8860B", value: 16, label: Em.I18n.t('colors.darkgoldenrod') }
    Em.Object.create { color: "#32CD32", value: 17, label: Em.I18n.t('colors.limegreen') }
    Em.Object.create { color: "#FFD700", value: 18, label: Em.I18n.t('colors.gold') }
    Em.Object.create { color: "#48D1CC", value: 19, label: Em.I18n.t('colors.mediumturquoise') }
    Em.Object.create { color: "#87CEEB", value: 20, label: Em.I18n.t('colors.>skyblue') }
    Em.Object.create { color: "#FF69B4", value: 21, label: Em.I18n.t('colors.hotpink') }
    Em.Object.create { color: "#CD5C5C", value: 22, label: Em.I18n.t('colors.indianred') }
    Em.Object.create { color: "#87CEFA", value: 23, label: Em.I18n.t('colors.lightskyblue') }
    Em.Object.create { color: "#6495ED", value: 24, label: Em.I18n.t('colors.cornflowerblue') }
    Em.Object.create { color: "#DC143C", value: 25, label: Em.I18n.t('colors.crimson') }
    Em.Object.create { color: "#FF8C00", value: 26, label: Em.I18n.t('colors.darkorange') }
    Em.Object.create { color: "#C71585", value: 27, label: Em.I18n.t('colors.mediumvioletred') }
    Em.Object.create { color: "#000000", value: 28, label: Em.I18n.t('colors.white') }
  ])

  didInsertElement: ->
    view = @
    @$('.colorselector').colorselector
      callback: (value, color)->
        view.set('value', color)
    @$('.colorselector').colorselector('setColor', @get('value'))
