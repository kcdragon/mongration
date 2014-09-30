require 'mongoid'
require 'rake'

require 'mongration/version'
require 'mongration/errors'
require 'mongration/rake_tasks'
require 'mongration/configuration'

module Mongration
  extend self

  autoload :CreateMigration, 'mongration/create_migration'
  autoload :File,            'mongration/file'
  autoload :Migrate,         'mongration/migrate'
  autoload :Migration,       'mongration/migration'
  autoload :NullOutput,      'mongration/null_output'
  autoload :Rollback,        'mongration/rollback'
  autoload :Status,          'mongration/status'

  # Performs the migrations. If no version is provided, all pending migrations will be run. If a version is provided, migrations will be run to that version (either up or down).
  #
  # @param [String, nil] version
  #
  # @return [Boolean] true if migration was successful, false otherwise
  #
  def migrate(version = nil)
    pending = ->(_) { File.pending.map(&:version).include?(_) }
    migrated = ->(_) { File.migrated.map(&:version).include?(_) }

    case version
    when nil
      files = File.pending
      Migrate::Up.new(files).perform

    when pending
      files = File.pending.select { |f| f.version <= version }
      Migrate::Up.new(files).perform

    when migrated
      files = File.migrated.select { |f| f.version > version }.reverse
      Migrate::Down.new(files).perform

    else
      out.puts("Invalid Version: #{version} does not exist.")
    end
  end

  # Rolls back (calls `down`) on the most recent migration(s).
  #
  # @param [Integer] number of migrations to rollback
  #
  # @return [void]
  #
  def rollback(step = 1)
    files = File.migrated.reverse.first(step)
    Migrate::Down.new(files).perform
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

  # Returns the version of most recently run migration. If there are no migrations that have run (all migrations are pending), it returns '0'.
  #
  # @return [String] version
  #
  def version
    if File.migrated.any?
      File.migrated.last.version
    else
      '0'
    end
  end

  # Returns the direction (up if it has been run, down otherwise), migration ID (version), and description of the migration.
  #
  # @return [Array] migration statuses
  #
  def status
    Status.migrations
  end

  def out
    if configuration.silent?
      @null_output ||= NullOutput.new
    else
      $stdout
    end
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
