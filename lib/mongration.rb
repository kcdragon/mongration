require 'rake'

require 'mongration/configuration'
require 'mongration/migration'
require 'mongration/migration/file'
require 'mongration/migration/null'
require 'mongration/next_migration_query'
require 'mongration/rake_task'
require 'mongration/version'

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
  def configuration
    @configuration ||= begin
                         config = Configuration.new
                         config.dir = File.join('db', 'migrate')
                         config
                       end
  end
end
