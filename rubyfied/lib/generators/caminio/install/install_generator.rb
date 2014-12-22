require 'rails/generators/migration'

module Caminio
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Installs caminio into your application"

      def setup_and_create

        copy_file "favicon.ico", "public/favicon.ico"
        copy_file "missing.png", "public/avatars/thumb/missing.png"

        application do
          "\n"+
          "    # caminio defaults \n"+
          "    config.caminio.domains_root = '#{Rails.root.join("..","domains")}'\n"+
          "\n"+
          "    config.i18n.default_locale = :de\n"+
          "    config.i18n.available_locales = [:en, :de]\n"+
          "    #config.time_zone = 'Vienna'\n"+
          "\n"+
          "    config.action_mailer.default_options = { from: 'no-reply@camin.io', host: 'camin.io' }"
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

      end

      def setup_routes
        route "mount Caminio::Engine, at: \"/caminio\""
      end

      def setup_doorkeeper
        gem 'doorkeeper'
        route 'use_doorkeeper'
        template "doorkeeper.rb", "config/initializers/doorkeeper.rb"
      end

      def setup_premailer
        gem 'nokogiri'
        gem 'premailer-rails'
      end

      desc "setup handlebars assets"
      def setup_handlebars_assets
        gem 'handlebars_assets'
        template "handlebars_assets.rb", "config/initializers/handlebars_assets.rb"
      end

      desc "setup and install bower"
      def setup_bower
        gem 'bower-rails'

        template "Bowerfile", "Bowerfile"
        template "bower_rails.rb", "config/initializers/bower_rails.rb"

        rake "bower:install"
      end

      def copy_fonts
        directory "fonts", "public/fonts"
      end

      def readme_file
        readme "README"
      end

    end
  end
end
