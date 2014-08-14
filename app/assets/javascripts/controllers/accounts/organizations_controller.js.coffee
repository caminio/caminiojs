App.AccountsOrganizationsController = Em.ObjectController.extend
  availableLangs: ['de','en']
  newOu: null
  currentOrganizationalUnit: null

  actions:

    createOrganizationalUnit: ->
      controller = @
      @get('newOu')
        .save()
        .then (newOu)->
          toastr.info Em.I18n.t('accounts.organizations.created', name: newOu.get('name'))
          controller.set('newOu', controller.store.createRecord('organizational_unit'))
