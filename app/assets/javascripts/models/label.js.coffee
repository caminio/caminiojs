App.Label = DS.Model.extend
  name:       DS.attr 'string'
  fgcolor:      DS.attr 'string', defaultValue: '#FFFFFF'
  bgcolor:      DS.attr 'string', defaultValue: '#C71585'
  bdcolor:      DS.attr 'string', defaultValue: ''
  position:   DS.attr 'number'
  category:   DS.attr 'string'
  styles: (->
    style = ""
    style += "background-color: #{@get('bgcolor')};" if @get('bgcolor')
    style += "color: #{@get('fgcolor')};" if @get('fgcolor')
    style += "border-color: #{@get('bdcolor')}" if @get('bdcolor')
    style
  ).property 'fgcolor', 'bgcolor', 'bdcolor'
