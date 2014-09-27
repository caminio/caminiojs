( function( App ){

  'use strict';

  window.App.CkeditorView = Ember.TextArea.extend({

    // template: Em.Handlebars.compile('<div class="ckeditor-wrap"><div class="ckeditor-toolbar"></div><div {{bind-attr class=":ckeditor-content-wrap classNames"}} contenteditable="true"></div></div>'),

    image: null,

    onImageChange: function(){
      this._editor.body.insertHtml('<img src="'+App.get('curImageUrl')+'">');
    }.observes('App.curImageUrl'),


    didInsertElement: function() {
      
      CKEDITOR.disableAutoInline = true;
      CKEDITOR.config.allowedContent = true;
      CKEDITOR.config.language = "de"
      CKEDITOR.config.uiColor = "#AADC6E"
      CKEDITOR.config.toolbar = [
        [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ],
        [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],
        '/',
        [ 'Bold', 'Italic' ]
      ]

      if( this.get('styles') )
        CKEDITOR.addCss( this.get('styles') )

      var view = this;
      this._editor = CKEDITOR.replace( this.$().get(0),{
        bodyClass: 'nlc',
        height: $(window).height()-400
      });
      // this._editor = CKEDITOR.inline( this.$('.ckeditor-content-wrap').get(0),{
      //   // extraPlugins: 'sharedspace',
      //   // removePlugins: 'floatingspace,resize',
      //   // sharedSpaces: {
      //   //   top: 'top'
      //   // }
      // });

      // this._editor.setData( view.get('value') );

      // CKEDITOR.appendTo( this.$('.ckeditor-toolbar').get(0), {
      //   extraPlugins: 'sharedspace',
      //   removePlugins: 'resize',
      //   sharedSpaces: {
      //     top: 'top'
      //   }
      // }, this.$('.ckeditor-content-wrap').get(0).innerHTML );

      this._editor.on('change', function(){
        view.set('value', view._editor.getData());
      });
    },

    willDestroyElement: function () {
      this._editor.destroy();
    },

    // selectedDidChange : function(){
    //   var self = this;
    //   if( self._preventLoop ){
    //     self._preventLoop = false;
    //     return;
    //   }
    //   if( self.get('value') )
    //     self._editor.setData(self.get('value'));
    // }.observes('value'),

    // swapVal: function(value){
    //   value = value || '';
    //   this.set('value',value);
    //   this._editor.setData(this.get('value'));
    //   this._editor.refresh();
    // }
    //
  });

  })( App );
