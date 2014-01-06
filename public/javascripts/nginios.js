jQuery( function($){

  $('.tooltip').tooltipster({
    theme: 'tooltipster-light'
  });

  // get translations
  $.getJSON( '/nginios/i18n_translations', function(resources){
    $.i18n.init({
      fallbackLng: 'en',
      ns: 'nginios',
      useCookie: false,
      detectLngFromHeaders: false,
      resStore: resources
    }, function(){
      continueInit();
    });
  });

  pager.Href.hash = '#!/';
  pager.extendWithPage(viewModel);
  ko.applyBindings(viewModel);
  pager.start();

  function continueInit(){
    console.log('nginios is ready'); 
  }

});
