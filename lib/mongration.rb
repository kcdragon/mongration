require 'rake'

require 'mongration/version'
require 'mongration/errors'

require 'mongration/configuration'
require 'mongration/create_migration'
require 'mongration/file'
require 'mongration/migrate'
require 'mongration/migration_file_writer'
require 'mongration/null_migration'
require 'mongration/rake_tasks'
require 'mongration/rollback'
require 'mongration/status'

require 'mongration/data_store/mongoid/store'
require 'mongration/data_store/in_memory/store'

module Mongration
  extend self
  extend Forwardable

  def_delegators :configuration, :dir, :data_store

  def migrate
    Migrate.perform(
      latest_migration.version + 1
    )
  end

  def rollback
    Rollback.perform(
      latest_migration
    )
  end

  # Creates a migration with the given name
  #
  # @return [String] name of the file created
  #
  def create_migration(name, options = {})
    CreateMigration.perform(
      name,
      options
    )
  end

  def version
    latest_migration.version
  end

  def status
    Status.migrations
  end

  def configure
    yield configuration if block_given?
  end

  def configuration
    @configuration ||= Configuration.new
  end

  private

  def latest_migration
    configuration.data_store.migrations.max_by(&:version) || NullMigration.new
  end
end

Mongration.configure do |config|
  config.dir = ::File.join('db', 'migrate')
  config.timestamps = true

  begin
    config.data_store = Mongration::DataStore::Mongoid::Store.new
  rescue Mongration::DataStore::Mongoid::ConfigNotFound
  end
end
