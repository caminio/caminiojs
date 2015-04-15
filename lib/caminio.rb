# 3rd
require "grape"
require "mongoid"
require "grape-entity"

require "roadie-rails"
require "paperclip"
require "mongoid_paperclip"

require 'jquery-rails'
require 'ember-rails' #unless Rails.env.test?

require 'request_store'

require 'tubesock'

# require "mongoid_paperclip"
# require "caminio/paperclip_grape_ext"
# require "doorkeeper"
#

require "caminio/version"
# require "caminio/schemas/row"

# setup caminio namespace for use in config/application.rb
require "caminio/config_namespace"

# require "caminio/access_rules"
require "caminio/userstamps"
require "caminio/timestamps"
require "caminio/access_rules"

# Rails engine
require "caminio/engine"

module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end
