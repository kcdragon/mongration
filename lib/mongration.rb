require 'mongration/version'

require 'mongration/errors'

require 'mongration/configuration'
require 'mongration/file'
require 'mongration/migration'
require 'mongration/migration_file_writer'
require 'mongration/null_migration'
require 'mongration/rake_task'

require 'mongration/data_store/mongoid/store'
require 'mongration/data_store/in_memory/store'

module Mongration
  extend self

  def migrate
    file_names = Mongration::File.all.map(&:file_name) - configuration.data_store.migrations.flat_map(&:file_names)

    migration = if file_names.present?
                  configuration.data_store.build_migration(
                    latest_migration.version + 1,
                    file_names
                  )
                else
                  NullMigration.new
                end

    Migration.new(migration).up
    migration.save
  end

  def rollback
    migration = latest_migration
    Migration.new(migration).down
    migration.destroy
  end

  def create_migration(name, options = {})
    snakecase = name.gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
    file_name = "#{next_migration_number}_#{snakecase}.rb"
    MigrationFileWriter.write(file_name, { dir: configuration.dir }.merge(options))
  end

  def configure
    yield configuration if block_given?
  end

  def configuration
    @configuration ||= Configuration.new
  end

  private

  def next_migration_number
    if configuration.timestamps?
      Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
    else
      latest_file = Mongration::File.latest

      number = if latest_file
                 latest_file.number + 1
               else
                 1
               end
      '%.3d' % number
    end
  end

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
