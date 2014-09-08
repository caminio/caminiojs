#= require jquery
#= require pace_options
#= require pace
#= require toastr
#= require 3rd/nicescroll.min
#= require 3rd/filesize.min
#= require 3rd/accounting.min
#= require blueimp-file-upload/js/vendor/jquery.ui.widget
#= require blueimp-file-upload/js/jquery.iframe-transport
#= require blueimp-file-upload/js/jquery.fileupload
#= require seiyria-bootstrap-slider
#= require jquery.cookie
#= require bootstrap/dist/js/bootstrap.min
#= require typeahead.js/dist/typeahead.bundle
#= require codemirror
#= require moment
#= require moment/locale/de
#
#= require select2
#= require selectize/dist/js/standalone/selectize.min
#
#= require bootbox
#
#= require handlebars
#= require ember
#= require ember-data
#= require cldr-plurals
#= require ember-i18n
#
# EMBER TABLE
#= require 3rd/jquery-ui.min
#= require 3rd/jquery.mousewheel.min
#= require 3rd/antiscroll
#= require ember-table
#
#= require_tree ./locales
#= require_self
#= require ./router
#= require_tree ./util
#= require_tree ./routes
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./views
#= require_tree ./controllers
#= require_tree ./components
#= require_tree ./templates

window.App = Ember.Application.create
  LOG_TRANSITIONS: true

App.ApplicationAdapter = DS.ActiveModelAdapter.extend
  host: '/caminio'
  headers:
    'X-CSRF-Token': '<%= csrf %>'

App.ApplicationStore = DS.Store.extend
  adapter: DS.RESTAdapter.extend

App.setAuthenticationBearer = (access_token, user)->
  Ember.$.ajaxSetup
    headers:
      'Authorization': 'Bearer ' + access_token
  return unless user
  App.set 'currentUser', user
  App.setLang( user.get('locale') )
  currentOuCookie = Ember.$.cookie 'caminio-session-ou'
  ou = user.get('organizational_units').findBy('id', currentOuCookie )
  if ou
    App.set 'currentOu', ou
  else
    App.set 'currentOu', user.get('organizational_units.firstObject')
  $('body').removeClass('authorization-required')
  Ember.$.ajaxSetup
    headers:
      'Ou': App.get('currentOu.id')

# ember i18n
Ember.View.reopen Em.I18n.TranslateableAttributes

# DS.ArrayTransform = DS.Transform.extend
#   deserialize: (serialized)->
#     Ember.typeOf(serialized) == "array" ? serialized : []
#
#   serialize: (deserialized)->
#     type = Ember.typeOf(deserialized)
#     if type == 'array'
#       return deserialized
#     else if type == 'string'
#       return deserialized.split(',').map( (item)->
#         Em.$.trim(item)
#       )
#     else
#       return []

# App.register("transform:array", DS.ArrayTransform)
#
DS.ObjectTransform = DS.Transform.extend
  deserialize: (serialized)->
    return {} if Em.isNone(serialized)
    # return {} if !serialized || Em.isNone(serialized)
    serialized

  serialize: (deserialized)->
    return {} if Em.isNone(deserialized)
    # return {} if !deserialized || Em.isNone(deserialized)
    deserialized


App.register("transform:object", DS.ObjectTransform)

App.setLang = (lang)->
  moment.locale(lang)
  CLDR.defaultLanguage = lang
  Em.I18n.translations = Em.I18n.availableTranslations[lang]

App.setLang( $('html').attr('lang') )

window.AVAILABLE_LANGS = ['de','en']

window.ACCESS =
  NONE: 0
  READ: 1
  WRITE: 2
  SHARE: 3
  FULL: 4

$('body').on('mouseover', '[rel=tooltip]', (e)->
  return if $(@).hasClass('tooltip')
  $(@).tooltip()
)
