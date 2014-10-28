( function( App ){

  'use strict';

  window.App.CodeMirrorView = Ember.TextArea.extend({

    classNames: ['CodeMirror'],
    mode: 'markdown',

    didInsertElement: function() {
      this._codeMirror = CodeMirror.fromTextArea( this.$()[0], {
          mode: this.get('mode'),
          tabMode: 'indent',
          lineWrapping: true
      });
      var self = this;
      this._codeMirror.on('change', function(){
        self._preventLoop = true;
        self.set('value', self._codeMirror.getValue());
      });

      this.$().parent().find('.CodeMirror-vscrollbar').niceScroll();
    },

    willDestroyElement: function () {
      this._codeMirror.toTextArea();
    },

    selectedDidChange : function(){
      var self = this;
      if( self._preventLoop ){
        self._preventLoop = false;
        return;
      }
      if( self.get('value') )
        self._codeMirror.setValue(self.get('value'));
    }.observes('value'),

    swapVal: function(value){
      value = value || '';
      this.set('value',value);
      this._codeMirror.setValue(this.get('value'));
      this._codeMirror.refresh();
    }

  });

  })( App );
