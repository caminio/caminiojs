#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-31 18:32:22
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-31 18:38:27

class Users::API < Grape::API

  version 'v1', using: :header, vendor: 'caminio', cascade: false
  format :json
  default_format :json

  helpers Caminio::API::Helpers

  get '/' do
    authenticate!
    { messages: Messages.where().load }
  end

end