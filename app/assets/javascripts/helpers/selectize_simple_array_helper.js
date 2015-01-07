Caminio.SelectizeSimpleArrayView = Ember.Select.extend({

  prompt: Em.I18n.t('please_select'),
  
  classNames: ['ember-selectize'],
  
  search: false,

  willInsertElement: function(){
    if( this.get('noPrompt') )
      this.set('prompt','');
    if( this.get('promptTranslation') )
      this.set('prompt', Em.I18n.t(this.get('promptTranslation')));
  },

  didInsertElement: function() {
    Ember.run.scheduleOnce('afterRender', this, 'processChildElements');
  },

  processChildElements: function() {
    var self = this;
    var options = {};
    if( !this.get('search') )
      options.minimumResultsForSearch = -1;

    var $select = this.$().selectize( options );
    self.selectize = $select[0].selectize;
    $select
      .on('change', function(){
        Em.run.later(function(){
          self.set('value', self.selectize.getValue());
        },10);
      });

  },

  willDestroyElement: function () {
    this.selectize.destroy()
  },

  // selectedDidChange : function(){
  //   var self = this;
  //   Ember.run.later( function(){
  //     if( !self.$() ) return;
  //     self.selectize.setValue( self.get('value') );
  //     console.log(self.get('value'));
  //   },100);
  // }.observes('value')

});
