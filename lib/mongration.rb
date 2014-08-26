require 'mongration/errors'

require 'mongration/configuration'
require 'mongration/file'
require 'mongration/migration'
require 'mongration/null_migration'
require 'mongration/rake_task'
require 'mongration/version'

require 'mongration/data_store/mongoid/store'
require 'mongration/data_store/in_memory/store'

module Mongration
  extend self

  def migrate
    file_names = all_file_names - migrated_file_names

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

  def create_migration(name)
    snake_case = name.gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
    file_name = "#{'%.3d' % next_migration_number}_#{snake_case}.rb"
    class_name = Mongration::File.new(file_name).class_name

    ::File.open(::File.join(dir, file_name), 'w') do |file|
      file.write(<<EOS
class #{class_name}
  def self.up
  end

  def self.down
  end
end
EOS
      )
    end
  end

  def configure
    yield configuration if block_given?
  end

  private

  def next_migration_number
    if timestamps?
      Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
    else
      latest_file = all_file_names.map { |file_name| Mongration::File.new(file_name) }.sort.max

      if latest_file
        latest_file.number + 1
      else
        1
      end
    end
  end

  def latest_migration
    data_store.migrations.sort_by(&:version).reverse.first || NullMigration.new
  end

  def all_file_names
    Dir[::File.join(dir, '*.rb')].map do |path|
      path.pathmap('%f')
    end
  end

  def migrated_file_names
    data_store.migrations.flat_map do |migration|
      migration.file_names
    end
  end

  def configuration
    @configuration ||= Configuration.new
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
end

Mongration.configure do |config|
  config.dir = ::File.join('db', 'migrate')

  begin
    config.data_store = Mongration::DataStore::Mongoid::Store.new
  rescue Mongration::DataStore::Mongoid::ConfigNotFound
  end
end
