require 'mongration/errors'

require 'mongration/configuration'
require 'mongration/file'
require 'mongration/migration'
require 'mongration/next_migration_query'
require 'mongration/null_migration'
require 'mongration/rake_task'
require 'mongration/version'

require 'mongration/data_store/mongoid/store'
require 'mongration/data_store/in_memory/store'

module Mongration
  extend self

  def migrate
    file_names = NextMigrationQuery.file_names

    migration = if file_names.present?
                  data_store.build_migration(
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

  def latest_migration
    data_store.migrations.sort_by(&:version).reverse.first || NullMigration.new
  end

  def configure
    yield configuration if block_given?
  end

  def method_missing(method, *args)
    if configuration.respond_to?(method, *args)
      configuration.send(method, *args)
    else
      super
    end
  end

  def respond_to?(method, *args)
    super || configuration.respond_to?(method, *args)
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end

Mongration.configure do |config|
  config.dir = ::File.join('db', 'migrate')

  begin
    config.data_store = Mongration::DataStore::Mongoid::Store.new
  rescue Mongration::DataStore::Mongoid::ConfigNotFound
  end
end
