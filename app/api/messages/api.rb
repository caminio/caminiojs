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
    user_messages = UserMessage.where( user: current_user, read: false ).load
    messages = []
    user_messages.each do |user_message|
      messages.push( user_message.message )
    end
    { messages: messages }
  end

end