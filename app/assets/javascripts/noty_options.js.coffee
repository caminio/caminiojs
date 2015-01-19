$.noty.defaults =
  layout: 'topRight'
  theme: 'relax'
  type: 'alert'
  text: ''
  dismissQueue: true
  template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>'
  animation:
    open: 'animated bounceInRight'
    close: 'animated bounceOutRight'
    easing: 'swing'
    speed: 500
  timeout: false
  force: false
  modal: false
  maxVisible: 5
  killer: false
  closeWith: ['click']
  buttons: false
  callback:
    onShow: (->)
    afterShow: (->)
    onClose: (->)
    afterClose: (->)
    onCloseClick: (->)
