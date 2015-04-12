module Caminio
  class Engine < ::Rails::Engine

    isolate_namespace Caminio

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[File.join( File.expand_path('../../../',__FILE__), 'app', 'api')]

    config.paths.add File.join('app', 'entities'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[File.join( File.expand_path('../../../',__FILE__), 'app', 'entities')]

    # rspec
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( caminio-3rd.js
                                                        caminio.js 
                                                        caminio.css
                                                        mailer.css
                                                        3rd/bootstrap.min.css
                                                        logo_*.png
                                                        *.otf
                                                        *.eot
                                                        *.svg
                                                        *.ttf
                                                        *.woff
                                                        .woff2
                                                        )

    end

    initializer :mongoid do
      Mongoid.load!( Rails.root.join "config/mongoid.yml" )
    end

    # initializer :handlebars_assets do
    #   HandlebarsAssets::Config.ember = true
    # end

    # if defined?( ActiveRecord )
    #   ActiveRecord::Base.send( :include, Caminio::Schemas::Row )
    # end
    #
    # initializer :append_migrations do |app|
    #   unless app.root.to_s.match root.to_s
    #     config.paths["db/migrate"].expanded.each do |expanded_path|
    #       app.config.paths["db/migrate"] << expanded_path
    #     end
    #   end
    # end

  end
end
