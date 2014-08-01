#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-31 18:32:22
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-08-01 09:38:38

class Messages::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    authenticate!
    query = UserMessage.where( user: current_user )
    query = query.where( read: !!/t|1|true/.match(params['read']) ) if params['read']
    user_messages = query.load
    messages = []
    user_messages.each do |user_message|
      messages.push( user_message.message )
    end
    { messages: messages }
  end

  post '/' do
    authenticate!

  end

  get '/:id' do
    authenticate!
    message = Message.find_by( id: params['id'] )
    user_message = UserMessage.where( message: message, user: current_user ) 
    message = user_message ? message : {}
    { message: message }
  end

  put '/:id' do
    authenticate!
    # data = params['message']

    { message: {} }
  end

  delete '/:id' do
    authenticate!

  end

end 