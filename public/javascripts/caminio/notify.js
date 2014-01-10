define(function(require) {

  var notify = function notify( message, options ){
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

    if( $(document).scrollTop() > 0 ){
      var oldPos = parseInt($('#message').css('top').replace('px',''));
      $('#message').css('top', $(document).scrollTop()+49);
      setTimeout(function(){
        $message.animate({ top: oldPos }, 500);
      },1500);
    }
  }

  notify.error = function( message, options ){
    options = options || {};
    options.error = true;
    console.log(message);
    if( typeof(message) === 'object' && message.responseJSON ){
      if( typeof(message.responseJSON.error) === 'object' )
        throw 'notify.error handling error objects is not implemented yet';
      return notify( message.responseJSON.error, options );
    }
    return notify('not recognized error in notify.error', { error: true });
  }

  return notify;

});
