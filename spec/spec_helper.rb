ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'rack/test'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

module RspecHelper
  module CaminioAccountsHelper

    def app
      Rack::Builder.new do
        use RequestStore::Middleware
        run V1::RootApi
      end
    end

    def json
      Hashie::Mash.new( JSON.parse last_response.body )
    end

  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
  config.color = true
  config.tty = true
  config.fail_fast = true
  config.formatter = :documentation # :progress, :html, :textmate
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:suite) do
    ActiveRecord::Migrator.up "db/migrate"
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include RspecHelper::CaminioAccountsHelper
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

end

Dir.glob( File.expand_path("../../app/{models,serializers}", __FILE__)+'/**/*.rb' ).each do |file|
  require file
end
