#
# mixin for Controllers
#
# validate:
#   <key>:
#     <validate_type>:
#       message: Em.I18n.t('message')
#
Caminio.Validations = Em.Mixin.create
  errors: Em.Object.create()
  isValid: (key)->

    return true unless @.get('validate')
    @resetValidationMessages()

    @.set('errors',Em.Object.create())
    validations = @.collectValidations()
    if key
      return validations.get(key).isValid()

    valid = false
    for key, options of @get('validate')
      valid = validations.get(key).isValid()
      $("input.#{key}_validation").focus()
      break unless valid
    valid

  collectValidations: ->
    validations = Em.Object.create()
    for key, options of @.get('validate')
      validations.set(key, Caminio.Validation.create(options) )
      validations.get(key).set('controller',@)
      validations.get(key).set('errors',@get('errors'))
      validations.get(key).set('content',@get('content'))
      validations.get(key).set('key',key)
    validations

  resetValidationMessages: ->
    @.set('valid',true)
    @.set('message',null)

# validation object
# returns true if all conditions are met
#
Caminio.Validation = Em.Object.extend
  isValid: ->

    if typeof(@.get('required')) == 'function'
      if message = @.get('required').call(@.get('controller'))
        @.get('controller').set('valid',false)
        @.get('controller').set('message', message )
        @.get('errors').set(@.get('key'), message)
    else if typeof(@.get('required')) == 'object' && !@.get('content.'+@.get('key'))
      @.get('controller').set('valid',false)
      @.get('controller').set('message', @.get('required.message'))
      @.get('errors').set(@.get('key'),@.get('required.message'))

    return @get('controller.valid') unless @get('content.'+@get('key'))

    if @.get('match') && @.get('match.regexp') && !@.get('content.'+@.get('key')).match(@.get('match.regexp'))
      @.get('controller').set('valid',false)
      @.get('controller').set('message', @.get('match.message'))
      @.get('errors').set(@.get('key'),@.get('match.message'))

    if typeof(@.get('custom')) == 'function'
      if message = @.get('custom').call(@.get('controller'))
        @.get('controller').set('valid',false)
        @.get('controller').set('message', message )
        @.get('errors').set(@.get('key'), message)

    @.get('controller.valid')
