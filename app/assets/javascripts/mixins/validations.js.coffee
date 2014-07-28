#
# mixin for Controllers
#
# validate:
#   <key>:
#     <validate_type>:
#       message: Em.I18n.t('message')
#
App.Validations = Em.Mixin.create
  isValid: (key)->

    return true unless @.get('validate')
    @.resetValidationMessages()

    @.set('errors',Em.Object.create())
    validations = @.collectValidations()
    if key
      return validations.get(key).isValid()

    valid = false
    for key, options of @.get('validate')
      valid = validations.get(key).isValid()
      break unless valid
    valid

  collectValidations: ->
    validations = Em.Object.create()
    for key, options of @.get('validate')
      validations.set(key, App.Validation.create(options) )
      validations.get(key).set('controller',@)
      validations.get(key).set('key',key)
    validations

  resetValidationMessages: ->
    @.set('valid',true)
    @.set('message',null)

# validation object
# returns true if all conditions are met
#
App.Validation = Em.Object.extend
  isValid: ->
    if @.get('match') && @.get('match.regexp') && !@.get('controller.'+@.get('key')).match(@.get('match.regexp'))
      @.get('controller').set('valid',false)
      @.get('controller').set('message', @.get('match.message'))
      @.get('controller.errors').set(@.get('key'),@.get('match.message'))

    if typeof(@.get('custom')) == 'function'
      if message = @.get('custom').call(@.get('controller'))
        @.get('controller').set('valid',false)
        @.get('controller').set('message', message )
        @.get('controller.errors').set(@.get('key'), message)

    if typeof(@.get('required')) == 'object' && !@.get('controller.'+@.get('key'))
      @.get('controller').set('valid',false)
      @.get('controller').set('message', @.get('required.message'))
      @.get('controller.errors').set(@.get('key'),@.get('required.message'))

    if typeof(@.get('required')) == 'function'
      if message = @.get('required').call(@.get('controller'))
        @.get('controller').set('valid',false)
        @.get('controller').set('message', message )
        @.get('controller.errors').set(@.get('key'), message)

    @.get('controller.valid')
