define(function(require) {

  return {
    message: message,
    toggleCheckbox: toggleCheckbox,
    generatePassword: generatePassword
  }

  function message( message, options ){
    if( arguments.length < 2 )
      options = message;
    options = options || {};
    var $closeBtn = $('<div class="close-btn"><i class="fa fa-times"></i></div>');
    $('#message').remove();
    var $message = $('<div id="message"/>')
    .append( $('<div class="content"/>').html( message ) )
    .append( $closeBtn );
    $message.on('click', function(){ $(this).slideUp(); });
    if( options.error )
      $message.addClass('error');

    $('body').append($message);
    $message.slideDown();
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

});
