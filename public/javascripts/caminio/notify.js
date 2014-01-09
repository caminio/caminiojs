define(function(require) {

  return function notify( message, options ){
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

});
