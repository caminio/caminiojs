Selectize.define('dropdown_footer', function(options) {

  'use strict';
  var plugin = this;

  options = $.extend({
    footerClass : 'selectize-dropdown-footer',
    btnWrapClass : 'selectize-dropdown-footer-btn-wrap',
    btnClass : 'selectize-dropdown-footer-btn btn btn-default',
    btnText : 'Add item',
    labelClass : 'selectize-dropdown-footer-label',
    closeClass : 'selectize-dropdown-footer-close',
    placeholderTitle: 'enter new name',
    html: function(data) {
      return $('<div/>')
      .addClass(data.footerClass)
      .append($('<div/>')
        .addClass(data.btnWrapClass)
        .append($('<a/>')
          .html(data.btnText)
          .addClass(data.btnClass)
        )
      );
    }
  }, options);

  plugin.setup = (function() {
    var original = plugin.setup;
    return function() {
      original.apply(this, arguments);
      plugin.$dropdown_footer = $(options.html(options));
      plugin.$dropdown.append(plugin.$dropdown_footer);
      plugin.$wrapper.on('mousedown','a',function(e){
        e.preventDefault(); 
        e.stopPropagation();
        plugin.clear();
        if( typeof(options.action) === 'function' )
          options.action.call(plugin, e);
      });
    };
  })();

});
