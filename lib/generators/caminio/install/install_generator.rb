require 'rails/generators/migration'

module Caminio
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Installs TASTENbOX into your application"

      def setup_and_create

        copy_file "favicon.ico", "public/favicon.ico"
        template "doorkeeper.rb", "config/initializers/doorkeeper.rb"

      end

      def setup_config

        application do
          "\n"+
          "    # caminio defaults \n"+
          "    config.caminio.domains_root = '#{Rails.root.join("..","domains")}'\n"+
          "\n"+
          "    config.i18n.default_locale = :de\n"+
          "    config.i18n.available_locales = [:en, :de]\n"+
          "    #config.time_zone = 'Vienna'\n"+
          "\n"+
          "    config.action_mailer.default_options = { from: 'no-reply@camin.io' }"
        end

        application(nil, env: "production") do
          "\n"+
          "  # action mailer configuration\n"+
          "\n"+
          "  config.action_mailer.delivery_method = :smtp\n" +
          "  config.action_mailer.smtp_settings = {\n" +
          "    address:              '<your mail host>',\n" +
          "    port:                 465,\n" +
          "    user_name:            '<your username>',\n" +
          "    password:             '<your password>',\n" +
          "    authentication:       'plain',\n" +
          "    enable_starttls_auto: true  }"+
          "\n"+
          "\n"+
          "  config.log_level = :warn"+
          "\n"+
          "\n"
        end

        route "mount Caminio::Engine, at: \"/caminio\""
        route 'use_doorkeeper'
        route 'get "/login" => "auth#login"'

        gem 'doorkeeper'
        gem 'bower-rails'

      end

      def run_other_generators
        # generate "doorkeeper:install"
        # generate 'ember:install'
      end

    end
  end
end
