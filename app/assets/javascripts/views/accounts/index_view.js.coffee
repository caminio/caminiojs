App.AccountsIndexView = Ember.View.extend
  layoutName: 'accounts/layout'
  didInsertElement: ->
    @$('.overflow-auto').niceScroll()
    $('#avatar-upload').fileupload
      url: '/caminio/users/avatar'
      paramName: 'avatar'
      dataType: 'json'
      done: (e, data)->
        alert "done"
