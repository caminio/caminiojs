require "yaml"
require "hashie"
require "active_record"
require "i18n"

class Caminio::Application

  def self.config
    @@config
  end

  def self.init_config
    @@config = Hashie::Mash.new
    db_config_file = Caminio::Root.join( 'config', 'database.yml' )
    
    if File::exists? Caminio::Root.join( 'config', 'mailer.rb' )
      require Caminio::Root.join( 'config', 'mailer' )
      ActionMailer::Base.append_view_path Caminio::Root.join( 'views', 'mailer' )
    end
   
    @@config.db = Hashie::Mash.new YAML::load_file( db_config_file )[Caminio::env]
    @@config
  end

  def self.db_migration_paths
    @@config ||= Hashie::Mash.new
    @@config.migration_paths
  end

  def self.add_migration_path(path)
    @@config ||= Hashie::Mash.new
    @@config.migration_paths << path unless @@config.migration_paths.include?( path )
  end

  def self.init_db_migration_paths
    @@config ||= self.init_config
    @@config.migration_paths ||= []
    migration_path = File::expand_path('../../../db/migrate',__FILE__)
    @@config.migration_paths << migration_path unless @@config.migration_paths.include?(migration_path)
  end

  def initialize
    @config = self.class.init_config
    self.class.init_db_migration_paths
    init_db
  end

  private

  def init_db
    ActiveRecord::Base.establish_connection( @config.db )
  end

end
