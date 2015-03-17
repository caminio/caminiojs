$.noty.defaults =
  layout: 'topRight'
  theme: 'relax'
  type: 'alert'
  text: ''
  dismissQueue: true
  template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>'
  animation:
    open: 'animated flipInX'
    close: 'animated flipOutX'
    easing: 'swing'
    speed: 300
  timeout: 3000
  force: false
  modal: false
  maxVisible: 5
  killer: false
  closeWith: ['click']
  callback:
    onShow: (->)
    afterShow: (->)
    onClose: (->)
    afterClose: (->)
    onCloseClick: (->)
