require 'caminio'
Caminio::Application.init_db_migration_paths
load "active_record/railties/databases.rake"

ActiveRecord::Base.configurations = YAML.load_file("config/database.yml")

ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.root                   = Rake.application.original_dir
  config.env                    = ENV['RACK_ENV'] || 'development'
  config.db_dir                 = 'db'
  config.migrations_paths       = Caminio::Application.db_migration_paths
  config.database_configuration = ActiveRecord::Base.configurations
end

namespace :db do
  task :environment do
    ActiveRecord::Base.establish_connection( (ENV['RACK_ENV'] || 'development').to_sym )
  end
end