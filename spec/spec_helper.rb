ENV['RAILS_ENV'] ||= 'test'

require "#{File::dirname(__FILE__)}/../lib/caminio"

Dir.glob( File.expand_path("../../app/{helpers,entities,api}", __FILE__)+'/**/*.rb' ).each do |file|
  require file
end

require File.expand_path("../dummy/config/environment.rb", __FILE__)
# require 'rspec/rails'
require 'rack/test'

require 'simplecov'
require 'hashie'
SimpleCov.start

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'request_store'
require 'database_cleaner'

require 'factory_girl'
Dir.glob("#{File::expand_path '../factories', __FILE__}/*.rb").each do |file|
  require file
end

module RspecHelper
  module CaminioHelper

    def app
      Rack::Builder.new do
        use RequestStore::Middleware
        run Caminio::API::Root
      end
    end

    def json
      Hashie::Mash.new( JSON.parse last_response.body )
    end

  end
end

RSpec.configure do |config|

  config.mock_with :rspec
  config.color = true
  config.tty = true
  config.fail_fast = true
  config.formatter = :documentation # :progress, :html, :textmate
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RspecHelper::CaminioHelper
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end

# as we are not using rails autoloader,
# we have to manually load all model and api files
Dir.glob( File.expand_path("../../app/{models}", __FILE__)+'/**/*.rb' ).each do |file|
  require file
end