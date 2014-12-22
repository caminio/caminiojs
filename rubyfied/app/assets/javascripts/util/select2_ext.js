(function( App ){

  'use strict';

  /**
   * example:
   * {{view App.Select2SelectView
        id="mySelect"
        contentBinding="App.staticData"
        optionValuePath="content.id"
        optionLabelPath="content.label"
        selectionBinding="controller.selectedId"}}

    {{view App.Select2SelectView
        class="pull-right select-num-rows"
        contentBinding="availableRows"
        valueBinding="numRows"}}

   *
   * advanced
   *    promptTranslation='my.translation' // will be translated using Em.I18n
   *    createAction='actionName' // action must be present in current controller
   *    createTranslation='my.create.translation' // same as promptTranslation
   *
   * the createAction gets:
   * @param name {String} the entered name
   * @param obj {JQuery} the jquery object of this select2 instance
   * 
   * the changeAction gets:
   * @param name {String} (the entered name)
   * @param obj {JQuery} jquery object of this select2 instance
   * 
   */
  Ember.Select2 = Ember.Select.extend({

    prompt: Em.I18n.t('please_select'),
    classNames: ['input-xlarge'],
    search: true,

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

      this.$().select2( options ).on('select2-open', function(){
        if( !self.get('createAction') )
          return;
        if( $('#select2-drop .select2-input').data('emberized') )
          return;
        $('#select2-drop .select2-input').data('emberized',true);
        $('#select2-drop .select2-input').on('keyup', function(e){
          if( e.keyCode === 27 )
            self.$().select2('close');
          if( $('#select2-drop .select2-results').length < 2 && this.value.length > 0 )
            $('#select2-drop .select2-no-results').text( Em.I18n.t(self.get('createTranslation')));
          else if( this.value.length > 0 )
            $('#select2-drop .select2-no-results').text( Em.I18n.t(self.get('promptTranslation')));
          if( e.keyCode !== 13 )
            return;
          self.get('controller').send(self.get('createAction'), this.value, self.$() );
          self.$().select2('close');
        });
      })
      .on('change', function(){
        if( self.get('changeAction') )
          self.get('controller').send(self.get('changeAction'), this.value, self.$() );
      });
      if( self.get('selectFirst') && self.get('content.length') > 0 )
        self.$().select2('val', self.get('content.firstObject.id'));
    },

    willDestroyElement: function () {
      this.$().select2("destroy");
    },

    selectedDidChange : function(){
      var self = this;
      setTimeout(function(){
        if( !self.$() ){ return; } // exit if view has gone meantime
        self.$().select2('val', self.get('value'));
      },100);
    }.observes('selection.@each')

  });

  Ember.Countries = Ember.Select.extend({

    prompt: Em.I18n.t('select_country'),
    classNames: ['input-xlarge'],

    willInsertElement: function(){

      var self = this;
      this.set('optionLabelPath', 'content.text');
      this.set('optionValuePath', 'content.id');

      var response = countryCodes[$('html').attr('lang')];
      var countries = [];
      for( var code in response )
        countries.push({ id: code, text: response[code] });
      countries.sort(function(a,b){
        if( a.text.toLowerCase() < b.text.toLowerCase() ) return -1;
        if( a.text.toLowerCase() > b.text.toLowerCase() ) return 1;
        if( a.text.toLowerCase() === b.text.toLowerCase() ) return 0;
      });
      self.set('content', countries);
      setTimeout(function(){
        if( self.get('value') )
          self.$().select2('val', self.get('value'));
        else if( App.get('_currentDomain.preferences.defaultCountry') )
          self.$().select2('val', App.get('_currentDomain.preferences.defaultCountry'));

      },100);
    },

    didInsertElement: function() {
      Ember.run.scheduleOnce('afterRender', this, 'processChildElements');
    },

    processChildElements: function() {
      var self = this;
      this.$().select2();
    },

    willDestroyElement: function () {
      this.$().select2("destroy");
    },

    selectedDidChange : function(){
      var self = this;
      setTimeout(function(){
        if( self.get('value') )
          self.$().select2('val', self.get('value'));
      },100);
    }.observes('value')

  });

  /**
   * TypeaheadTextFieldView
   * example:
   * {{view App.Select2AjaxTextFieldView
        source="/caminio/get/data.json?q=%QUERY"
        optionValuePath="content.id"
        optionLabelPath="content.label"
        valueBinding="controller.selectedId"}}

    {{view App.Select2SelectView
        class="pull-right select-num-rows"
        contentBinding="availableRows"
        valueBinding="numRows"}}

   *
   * advanced
   *    promptTranslation='my.translation' // will be translated using Em.I18n
   *    createAction='actionName' // action must be present in current controller
   *    createTranslation='my.create.translation' // same as promptTranslation
   *
   * the createAction gets:
   * @param name {String} name (the entered name)
   * @param elem {JQuery} the jquery object of this select2 instance
   *
   * the transformResultsAction gets:
   * @param data {Array}
   * @param page {JQuery} the current page if paging support is enabled
   *
   * and should return a select2 compatible result array
   *
   */
  Ember.Typeahead = Ember.TextField.extend({

    classNames: ['input-xlarge'],

    didInsertElement: function() {
      Ember.run.scheduleOnce('afterRender', this, 'processChildElements');
    },

    processChildElements: function() {
      var self = this;
      var sources;
      if( this.get('source') )
        sources = new Bloodhound({
          datumTokenizer: Bloodhound.tokenizers.obj.whitespace( self.get('optionValuePath') ),
          queryTokenizer: Bloodhound.tokenizers.whitespace,
          remote:  this.get('source')
        });
      else if( this.get('localContent') )
        sources = new Bloodhound({
          datumTokenizer: Bloodhound.tokenizers.obj.whitespace( self.get('optionValuePath')),
          queryTokenizer: Bloodhound.tokenizers.whitespace,
          local: $.map( this.get('localContent'), function(c){ return { value: c }; })
        });
      if( !sources )
        return;

      sources.initialize();

      this.$().typeahead( null, {
        displayKey: self.get('optionValuePath'),
        source: sources.ttAdapter()
      });
    },

    willDestroyElement: function () {
      this.$().typeahead('destroy');
    }

  });

})( App );
