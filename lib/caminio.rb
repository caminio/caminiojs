require "grape"
require 'action_mailer'
require "active_record"
require "active_model_serializers"
require 'grape-active_model_serializers'

require "caminio/version"
require "caminio/env"
require "caminio/root"
require "caminio/application"

# disable annoying active record message
I18n.enforce_available_locales = false

module Caminio

  # define API for app/api files to be loaded in load_app_files
  module API
  end

  def self.init
    @@app = Application.new
    self.load_app_files
  end

  def self.load_app_files
    dir = File::expand_path '../../app', __FILE__
    Dir.glob( "#{dir}/{helpers,api,models,serializers,mailer}/**/*.rb" ).each do |file|
      require file
    end
    require "#{dir}/api"
  end

end
