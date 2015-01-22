module Caminio
  class Engine < ::Rails::Engine

    isolate_namespace Caminio

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[File.join( File.expand_path('../../../',__FILE__), 'app', 'api', '*')]

    # rspec
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( caminio.js 
                                                        caminio.css
                                                        mailer.css
                                                        loader.gif
                                                        3rd/font-awesome/*
                                                        3rd/bootstrap.min.css
                                                        3rd/font-awesome.css
                                                        3rd/fonts/*
                                                        logo_32x32.png
                                                        logo_64x64.png
                                                        logo_128x128.png
                                                        bootstrap/dist/fonts/glyphicons-halflings-regular.eot
                                                        bootstrap/dist/fonts/glyphicons-halflings-regular.woff
                                                        bootstrap/dist/fonts/glyphicons-halflings-regular.ttf)
    end

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
