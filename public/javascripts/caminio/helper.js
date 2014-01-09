define(function(require) {

  return {
    toggleCheckbox: toggleCheckbox,
    generatePassword: generatePassword,
    formatPrice: formatPrice
  }

  function toggleCheckbox(item, e){
    var $elem = e.target.nodeName === 'A' ? $(e.target) : $(e.target).closest('a');
    var $fa = $elem.find('.fa');
    if( $fa.hasClass('fa-square-o') ){
      $fa.removeClass('fa-square-o').addClass('fa-check-square-o');
      $elem.find('input[type=checkbox]').attr('checked', true);
    } else {
      $fa.removeClass('fa-check-square-o').addClass('fa-square-o');
      $elem.find('input[type=checkbox]').attr('checked', false);
    }
  }

  function generatePassword( len ){
    var length = len || 8,
    charset = "abcdefghijklnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    retVal = "";
    for (var i = 0, n = charset.length; i < length; ++i) {
      retVal += charset.charAt(Math.floor(Math.random() * n));
    }
    return retVal;
  }

  function formatPrice( price ){
    price = price.toString();
    if( price.split('.').length > 1 )
      price = price.split('.')[0] + ',' + (price.split('.')[1].length === 1 ? price.split('.')[1]+'0' : price.split('.')[1]);
    else
      price = price + ',--';
    return price;
  }

});
