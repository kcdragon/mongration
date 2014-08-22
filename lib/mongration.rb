require 'rake'

require 'mongration/configuration'
require 'mongration/migration'
require 'mongration/migration/null'
require 'mongration/next_migration_query'
require 'mongration/rake_task'
require 'mongration/version'

require 'mongration/data_store/mongoid/migration'

module Mongration
  extend self

  def migrate
    file_names_to_migrate = NextMigrationQuery.file_names_to_migrate

    Migration.
      next_migration_for(file_names_to_migrate).
      up!
  end

  def rollback
    Migration.latest_migration.down!
  end

  def configure
    yield configuration if block_given?
  end

  # @private
  def dir
    configuration.dir
  end

  # @private
  #
  # Interface for data_store_class
  # * .all
  # * .build(version, file_names)
  # * #version
  # * #file_names
  #
  def data_store_class
    configuration.data_store_class
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end

Mongration.configure do |config|
  config.dir = File.join('db', 'migrate')

  default_mongoid_config_path = File.join('config', 'mongoid.yml')
  if File.exists?(default_mongoid_config_path)
    config.mongoid_config_path = default_mongoid_config_path
  end

  config.data_store_class = Mongration::DataStore::Mongoid::Migration
end
