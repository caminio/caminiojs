module Caminio
  class Engine < ::Rails::Engine

    isolate_namespace Caminio

    initializer "assets_initializers.initialize_rails", :group => :assets do |app|
      require "#{Rails.root}/config/initializers/load_config.rb"
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile << %w(
        nothin/yet
      )
    end

    if defined?( ActiveRecord )
      ActiveRecord::Base.send( :include, Iox::DocumentSchema )
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
