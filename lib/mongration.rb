require 'mongoid'
require 'rake'

require 'mongration/version'
require 'mongration/errors'

require 'mongration/versionable'
require 'mongration/file'
require 'mongration/migration'

require 'mongration/configuration'
require 'mongration/create_migration'
require 'mongration/migrate'
require 'mongration/migration_file_writer'
require 'mongration/rake_tasks'
require 'mongration/rollback'
require 'mongration/status'

module Mongration
  extend self
  extend Forwardable

  def_delegators :configuration, :dir

  def migrate
    Migrate.new.perform
  end

  def rollback
    Rollback.new.perform
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
    return '0' unless Migration.exists?
    Migration.last.version
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
end

Mongration.configure do |config|
  config.dir = ::File.join('db', 'migrate')
  config.timestamps = true

  begin
    config.config_path = ::File.join('config', 'mongoid.yml')
  rescue Mongration::Configuration::ConfigNotFound
  end
end
