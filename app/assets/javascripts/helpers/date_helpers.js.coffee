Ember.Handlebars.registerBoundHelper 'timeAgo', (date)->
  parsedDate = moment(date)
  new Handlebars.SafeString('<time datetime="'+parsedDate.format()+'">'+parsedDate.fromNow()+'</time>')


Ember.Handlebars.registerBoundHelper 'formatDate', (date,options)->
  console.log arguments
  formatter = if options.hash.format then options.hash.format else 'LLL'
  parsedDate = if date then moment(date) else moment()
  formattedDate = parsedDate.format(formatter)
  new Handlebars.SafeString("<time datetime=#{parsedDate.toISOString()}>#{formattedDate}</time>")

Ember.Handlebars.registerBoundHelper 'smartDate', (date)->
  parsedDate = if date then moment(date) else moment()
  str = ''
  if( parsedDate.clone().subtract('d',7) >= moment().startOf('day').subtract('d',8) )
    if( parsedDate.format('YYYY-MM-DD') == moment().format('YYYY-MM-DD') )
      str = Em.I18n.t('today') + ', ' + parsedDate.format('HH:mm') + ' ' + Em.I18n.t('o_clock')
    else if( parsedDate.format('YYYY-MM-DD') == moment().subtract('d',1).format('YYYY-MM-DD') )
      str = Em.I18n.t('yesterday') + ', ' + parsedDate.format('HH:mm') + ' ' + Em.I18n.t('o_clock')
    else
      str = parsedDate.format('dddd HH:mm') + ' ' + Em.I18n.t('o_clock')
  else
    str = parsedDate.format('DD. ')
    if( parsedDate.format('MM.YYYY') == moment().format('MM.YYYY') )
      str += parsedDate.format('MMMM')
    else
      str += parsedDate.format('MMMM')
      if( parsedDate.format('YYYY') != moment().format('YYYY') )
        str += parsedDate.format('YYYY')
  new Handlebars.SafeString("<time title='" + parsedDate.format('LLLL') + "' datetime='" + parsedDate.format('LLLL') +"'>" + str + "</time>")
