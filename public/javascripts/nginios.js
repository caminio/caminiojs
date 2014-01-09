jQuery( function($){

  $('.tooltip').tooltipster({
    theme: 'tooltipster-light'
  });

  // get translations
  $.getJSON( '/caminio/i18n_translations', function(resources){
    $.i18n.init({
      fallbackLng: 'en',
      ns: 'caminio',
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
    console.log('caminio is ready'); 
  }

});
