App.AceView = Ember.View.extend
  tagName: 'div'
  classNames: ['ace-instance']
  mode: 'html'
  value: 'No content yet'
  enableSaveKeybinding: false

  didInsertElement: ->
    view = @
    @$().css('height',$(window).height()-200)
    editor = ace.edit(@$().attr('id'))
    editor.setTheme("ace/theme/dawn")
    editor.getSession().setMode("ace/mode/#{@get('mode')}")
    editor.setShowPrintMargin false
    editor.session.setTabSize 2
    editor.session.setUseSoftTabs true
    editor.setFontSize 14
    editor.setKeyboardHandler 'vim'

    if @get('enableSaveKeybinding')
      editor.commands.addCommand
        name: "replace"
        bindKey: 
          win: "Ctrl-s"
          mac: "Command-s"
        exec: ->
          view.get('controller').send('save')

    editor.setValue @get('value')

    @get('controller').set('ace', editor)

