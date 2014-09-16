require 'mongoid'
require 'rake'

require 'mongration/version'
require 'mongration/errors'

require 'mongration/file'
require 'mongration/migration'

require 'mongration/migrate_all_up'
require 'mongration/migrate_down'
require 'mongration/migrate_up'

require 'mongration/configuration'
require 'mongration/create_migration'
require 'mongration/migration_file_writer'
require 'mongration/rake_tasks'
require 'mongration/rollback'
require 'mongration/status'

module Mongration
  extend self
  extend Forwardable

  def_delegators :configuration, :dir

  def migrate(version = nil)
    pending = ->(_) { File.pending.map(&:version).include?(_) }
    migrated = ->(_) { File.migrated.map(&:version).include?(_) }

    case version
    when nil
      MigrateAllUp.perform

    when pending
      MigrateUp.new(version).perform

    when migrated
      MigrateDown.new(version).perform

    else
      false
    end
  end

  def rollback
    Rollback.perform
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
    File.migrated.last.version
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
