( function( App ){

  'use strict';

  window.App.CkeditorView = Ember.TextArea.extend({

    classNames: ['ckeditor-wrap'],

    didInsertElement: function() {
      this._editor = CKEDITOR.replace( this.$().attr('id') )
      var view = this;
      this._editor.on('change', function(){
        view.set('value', view._editor.getValue());
      });
    },

    willDestroyElement: function () {
      // this._editor.();
    },

    selectedDidChange : function(){
      var self = this;
      if( self._preventLoop ){
        self._preventLoop = false;
        return;
      }
      if( self.get('value') )
        self._editor.setValue(self.get('value'));
    }.observes('value'),

    swapVal: function(value){
      value = value || '';
      this.set('value',value);
      this._editor.setValue(this.get('value'));
      this._editor.refresh();
    }

  });

  })( App );
